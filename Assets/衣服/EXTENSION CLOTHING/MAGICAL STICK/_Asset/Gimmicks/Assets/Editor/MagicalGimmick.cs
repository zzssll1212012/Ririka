using UnityEngine;
using UnityEditor;
using nadena.dev.ndmf;
using nadena.dev.modular_avatar.core;
using EXTENSIONCLOTHING.MSCG;
using VRC.SDK3.Dynamics.PhysBone.Components;
using VRC.SDKBase;
using System.Collections.Generic;

[assembly: ExportsPlugin(typeof(MagicalGimmick))]

namespace EXTENSIONCLOTHING.MSCG
{
    public class MagicalGimmick : Plugin<MagicalGimmick>
    {
        protected override void Configure()
        {
            InPhase(BuildPhase.Transforming)
                .BeforePlugin("nadena.dev.modular-avatar")
                .Run("Create toggle animations", ctx =>
                {
                    var objs = ctx.AvatarRootObject.GetComponentsInChildren<MagicalGimmickMain>();
                    foreach (var obj in objs)
                    {
                        var movedObjects = obj.MoveSpecifiedObjects(obj.MagicalStickObject);
                        obj.AssignRenderersForAllObjects();
                        CreateToggleAnimations(obj, movedObjects);
                        UpdateShapeKeyAnimations(obj.ShapekeyAnimationClip);

                        if (obj.ParticleSystemPrefab != null)
                        {
                            obj.DuplicateParticleSystemForMeshes(obj.MagicalStickObject, obj.GetMagicalStickMeshRenderers(), obj.GetMagicalStickSkinnedMeshRenderers());
                        }

                        CreateMagicalStickLayerControlAnimation(obj);
                    }
                });
        }

        private void CreateToggleAnimations(MagicalGimmickMain obj, List<GameObject> movedObjects)
        {
            if (obj.HideAnimationClip == null || obj.ShowAnimationClip == null)
            {
                return;
            }

            Transform root = GetAvatarDescriptorRoot(obj.transform);

            AddKeyframesForRenderers(obj.GetMeshRenderers(), obj.HideAnimationClip, false, root);
            AddKeyframesForRenderers(obj.GetMeshRenderers(), obj.ShowAnimationClip, true, root);

            AddKeyframesForRenderers(obj.GetSkinnedMeshRenderers(), obj.HideAnimationClip, false, root);
            AddKeyframesForRenderers(obj.GetSkinnedMeshRenderers(), obj.ShowAnimationClip, true, root);

            AddKeyframesForRenderers(obj.GetMagicalStickMeshRenderers(), obj.HideAnimationClip, true, root);
            AddKeyframesForRenderers(obj.GetMagicalStickMeshRenderers(), obj.ShowAnimationClip, false, root);

            AddKeyframesForRenderers(obj.GetMagicalStickSkinnedMeshRenderers(), obj.HideAnimationClip, true, root);
            AddKeyframesForRenderers(obj.GetMagicalStickSkinnedMeshRenderers(), obj.ShowAnimationClip, false, root);

            AddKeyframesForPhysBones(obj.CostumeObjects, obj.HideAnimationClip, false, root);
            AddKeyframesForPhysBones(obj.CostumeObjects, obj.ShowAnimationClip, true, root);

            if (obj.MagicalStickObject != null)
            {
                AddKeyframesForPhysBones(new List<GameObject> { obj.MagicalStickObject }, obj.HideAnimationClip, true, root);
                AddKeyframesForPhysBones(new List<GameObject> { obj.MagicalStickObject }, obj.ShowAnimationClip, false, root);
            }

            AddKeyframesForGameObjects(movedObjects, obj.HideAnimationClip, true, root);
            AddKeyframesForGameObjects(movedObjects, obj.ShowAnimationClip, false, root);

            AddKeyframesForGameObjects(obj.ChangedManualWear, obj.HideAnimationClip, true, root);
            AddKeyframesForGameObjects(obj.ChangedManualWear, obj.ShowAnimationClip, false, root);
        }

        private void CreateMagicalStickLayerControlAnimation(MagicalGimmickMain obj)
        {
            if (obj.LayerControlClip == null || obj.MagicalStickObject == null) return;

            Transform root = GetAvatarDescriptorRoot(obj.transform);

            AddKeyframesForRenderers(obj.GetMagicalStickMeshRenderers(), obj.LayerControlClip, false, root);
            AddKeyframesForRenderers(obj.GetMagicalStickSkinnedMeshRenderers(), obj.LayerControlClip, false, root);

            if (obj.MagicalStickObject != null)
            {
                AddKeyframesForPhysBones(new List<GameObject> { obj.MagicalStickObject }, obj.LayerControlClip, false, root);
            }
        }

        private void AddKeyframesForRenderers(IEnumerable<Renderer> renderers, AnimationClip clip, bool isVisible, Transform root)
        {
            foreach (var renderer in renderers)
            {
                if (renderer != null)
                {
                    AddKeyframesForRenderer(renderer, clip, isVisible, root);
                }
            }
        }

        private void AddKeyframesForRenderer(Renderer renderer, AnimationClip clip, bool isVisible, Transform root)
        {
            if (renderer == null) return;

            string path = GetRelativePath(root, renderer.transform);

            EditorCurveBinding binding = new EditorCurveBinding
            {
                path = path,
                type = typeof(GameObject),
                propertyName = "m_IsActive"
            };

            AnimationCurve curve = AnimationCurve.Constant(0, 1, isVisible ? 1f : 0f);
            AnimationUtility.SetEditorCurve(clip, binding, curve);
        }

        private void AddKeyframesForPhysBones(IEnumerable<GameObject> objects, AnimationClip clip, bool isActive, Transform root)
        {
            foreach (var obj in objects)
            {
                var physBones = obj.GetComponentsInChildren<VRCPhysBone>();

                foreach (var physBone in physBones)
                {
                    if (physBone == null) continue;

                    string path = GetRelativePath(root, physBone.transform);

                    EditorCurveBinding binding = new EditorCurveBinding
                    {
                        path = path,
                        type = typeof(VRCPhysBone),
                        propertyName = "m_Enabled"
                    };

                    AnimationCurve curve = AnimationCurve.Constant(0, 1, isActive ? 1f : 0f);
                    AnimationUtility.SetEditorCurve(clip, binding, curve);
                }
            }
        }

        private void AddKeyframesForGameObjects(IEnumerable<GameObject> objects, AnimationClip clip, bool isActive, Transform root)
        {
            foreach (var obj in objects)
            {
                if (obj != null)
                {
                    AddKeyframesForGameObject(obj, clip, isActive, root);
                }
            }
        }

        private void AddKeyframesForGameObject(GameObject obj, AnimationClip clip, bool isActive, Transform root)
        {
            string path = GetRelativePath(root, obj.transform);

            EditorCurveBinding binding = new EditorCurveBinding
            {
                path = path,
                type = typeof(GameObject),
                propertyName = "m_IsActive"
            };

            AnimationCurve curve = AnimationCurve.Constant(0, 1, isActive ? 1f : 0f);
            AnimationUtility.SetEditorCurve(clip, binding, curve);
        }
        public void UpdateShapeKeyAnimations(AnimationClip animationClip)
        {
            if (animationClip == null) return;

            var bindings = AnimationUtility.GetCurveBindings(animationClip);
            foreach (var binding in bindings)
            {
                if (binding.type == typeof(SkinnedMeshRenderer) && binding.propertyName.StartsWith("blendShape."))
                {
                    var gameObject = GameObject.Find(binding.path);
                    if (gameObject == null) continue;

                    var renderer = gameObject.GetComponent<SkinnedMeshRenderer>();
                    if (renderer == null) continue;

                    var mesh = renderer.sharedMesh;
                    if (mesh == null) continue;

                    int shapeKeyIndex = mesh.GetBlendShapeIndex(binding.propertyName.Replace("blendShape.", ""));
                    if (shapeKeyIndex < 0) continue;

                    float shapeKeyValue = renderer.GetBlendShapeWeight(shapeKeyIndex);

                    AnimationCurve curve = AnimationCurve.Constant(0, animationClip.length, shapeKeyValue);
                    AnimationUtility.SetEditorCurve(animationClip, binding, curve);
                }
            }
        }
        private string GetRelativePath(Transform root, Transform target)
        {
            string path = "";

            while (target != null && target != root)
            {
                path = string.IsNullOrEmpty(path) ? target.name : target.name + "/" + path;
                target = target.parent;
            }

            return path;
        }

        private Transform GetAvatarDescriptorRoot(Transform transform)
        {
            VRC_AvatarDescriptor avatarDescriptor = transform.GetComponentInParent<VRC_AvatarDescriptor>();
            return avatarDescriptor != null ? avatarDescriptor.transform : transform.root;
        }
    }
}