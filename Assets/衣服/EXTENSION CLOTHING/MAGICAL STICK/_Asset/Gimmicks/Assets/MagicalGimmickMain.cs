using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Animations;
using VRC.SDKBase;
using VRC.SDK3.Dynamics.PhysBone.Components;

namespace EXTENSIONCLOTHING.MSCG
{
    [ExecuteInEditMode]
    [DisallowMultipleComponent]
    [AddComponentMenu("Modular Avatar/EXTENSION CLOTHING/MA Magical Gimmick")]
    public class MagicalGimmickMain : MonoBehaviour, IEditorOnly
    {
        [SerializeField] private List<GameObject> costumeObjects = new List<GameObject>();
        [SerializeField] private GameObject magicalStickObject;
        [SerializeField] private AnimationClip hideAnimationClip;
        [SerializeField] private AnimationClip showAnimationClip;
        [SerializeField] private AnimationClip layerControlClip;
        [SerializeField] private AnimationClip shapekeyAnimationClip;

        [SerializeField] private ParticleSystem particleSystemPrefab;
        [SerializeField] private GameObject particleTree;
        [SerializeField] private Transform magicalHairHeadBone;
        [SerializeField] private List<GameObject> changedManualWear = new List<GameObject>();

        public List<GameObject> CostumeObjects => costumeObjects;
        public GameObject MagicalStickObject => magicalStickObject;
        public ParticleSystem ParticleSystemPrefab => particleSystemPrefab;
        public GameObject ParticleTree => particleTree;
        public List<GameObject> ChangedManualWear => changedManualWear;

        private List<MeshRenderer> meshRenderers = new List<MeshRenderer>();
        private List<SkinnedMeshRenderer> skinnedMeshRenderers = new List<SkinnedMeshRenderer>();
        private List<MeshRenderer> magicalStickMeshRenderers = new List<MeshRenderer>();
        private List<SkinnedMeshRenderer> magicalStickSkinnedMeshRenderers = new List<SkinnedMeshRenderer>();

        public AnimationClip HideAnimationClip => hideAnimationClip;
        public AnimationClip ShowAnimationClip => showAnimationClip;
        public AnimationClip LayerControlClip => layerControlClip;
        public AnimationClip ShapekeyAnimationClip => shapekeyAnimationClip;

        public List<MeshRenderer> GetMeshRenderers()
        {
            return meshRenderers;
        }

        public List<SkinnedMeshRenderer> GetSkinnedMeshRenderers()
        {
            return skinnedMeshRenderers;
        }

        public List<MeshRenderer> GetMagicalStickMeshRenderers()
        {
            return magicalStickMeshRenderers;
        }

        public List<SkinnedMeshRenderer> GetMagicalStickSkinnedMeshRenderers()
        {
            return magicalStickSkinnedMeshRenderers;
        }

        private void OnValidate()
        {
            ResetAnimationClips();
        }

        public List<GameObject> MoveSpecifiedObjects(GameObject parent)
        {
            List<GameObject> movedObjects = new List<GameObject>();

            if (parent == null) return movedObjects;

            string[] hairObjects = { "Active Twin High", "Active Twin Low", "Active Twin", "Hairpin_1 Variant", "Hairpin_2 Variant", "Hairpin_3 Variant", "Hairpin_1", "Hairpin_2", "Hairpin_3" };
            foreach (Transform child in parent.transform)
            {
                foreach (string hairObject in hairObjects)
                {
                    if (child.name.Contains(hairObject))
                    {
                        MoveObjectToSpecifiedHierarchy(child.gameObject);
                        movedObjects.Add(child.gameObject);
                    }
                }
            }

            return movedObjects;
        }

        private void MoveObjectToSpecifiedHierarchy(GameObject obj)
        {
            if (magicalHairHeadBone != null)
            {
                obj.transform.SetParent(magicalHairHeadBone, true);
            }
        }


        public void AssignRenderersForAllObjects()
        {
            meshRenderers.Clear();
            skinnedMeshRenderers.Clear();
            magicalStickMeshRenderers.Clear();
            magicalStickSkinnedMeshRenderers.Clear();

            foreach (var obj in costumeObjects)
            {
                if (obj != null)
                {
                    AddRenderers(obj, meshRenderers, skinnedMeshRenderers);
                }
            }

            if (magicalStickObject != null)
            {
                AddMagicalStickRenderers(magicalStickObject);
            }
        }

        public void DuplicateParticleSystemForMeshes(GameObject parent, List<MeshRenderer> meshRenderers, List<SkinnedMeshRenderer> skinnedMeshRenderers)
        {
            /* メッシュ増えすぎる気がするので除外
            foreach (var renderer in meshRenderers)
            {
                CreateAndAssignParticleSystem(renderer, parent);
            }
            */

            foreach (var renderer in skinnedMeshRenderers)
            {
                CreateAndAssignParticleSystem(renderer, parent);
            }
        }

        private void CreateAndAssignParticleSystem(Renderer renderer, GameObject parent)
        {
            if (particleSystemPrefab == null || renderer == null) return;

            ParticleSystem newParticleSystem = Instantiate(particleSystemPrefab, renderer.transform.position, renderer.transform.rotation, ParticleTree.transform);

            if (newParticleSystem == null) return;

            var shape = newParticleSystem.shape;

            if (renderer is MeshRenderer meshRenderer)
            {
                shape.shapeType = ParticleSystemShapeType.Mesh;
                shape.meshRenderer = meshRenderer;
            }
            else if (renderer is SkinnedMeshRenderer skinnedMeshRenderer)
            {
                shape.shapeType = ParticleSystemShapeType.SkinnedMeshRenderer;
                shape.skinnedMeshRenderer = skinnedMeshRenderer;
            }

            int polygonCount = GetPolygonCount(renderer);
            var emission = newParticleSystem.emission;
            emission.rateOverTime = polygonCount / 20f;
        }

        private int GetPolygonCount(Renderer renderer)
        {
            Mesh mesh = null;

            if (renderer is MeshRenderer meshRenderer)
            {
                mesh = meshRenderer.GetComponent<MeshFilter>().sharedMesh;
            }
            else if (renderer is SkinnedMeshRenderer skinnedMeshRenderer)
            {
                mesh = skinnedMeshRenderer.sharedMesh;
            }

            return mesh != null ? mesh.triangles.Length / 3 : 0;
        }

        private void AddRenderers(GameObject obj, List<MeshRenderer> meshList, List<SkinnedMeshRenderer> skinnedMeshList)
        {
            meshList.AddRange(obj.GetComponentsInChildren<MeshRenderer>());
            skinnedMeshList.AddRange(obj.GetComponentsInChildren<SkinnedMeshRenderer>());

            meshList = new List<MeshRenderer>(new HashSet<MeshRenderer>(meshList));
            skinnedMeshList = new List<SkinnedMeshRenderer>(new HashSet<SkinnedMeshRenderer>(skinnedMeshList));
        }

        private void AddMagicalStickRenderers(GameObject obj)
        {
            magicalStickMeshRenderers.AddRange(obj.GetComponentsInChildren<MeshRenderer>(true));
            magicalStickSkinnedMeshRenderers.AddRange(obj.GetComponentsInChildren<SkinnedMeshRenderer>(true));

            magicalStickMeshRenderers = new List<MeshRenderer>(new HashSet<MeshRenderer>(magicalStickMeshRenderers));
            magicalStickSkinnedMeshRenderers = new List<SkinnedMeshRenderer>(new HashSet<SkinnedMeshRenderer>(magicalStickSkinnedMeshRenderers));
        }

        public void ResetAnimationClips()
        {
            if (hideAnimationClip != null)
            {
                hideAnimationClip.ClearCurves();
            }

            if (showAnimationClip != null)
            {
                showAnimationClip.ClearCurves();
            }

            if (layerControlClip != null)
            {
                layerControlClip.ClearCurves();
            }
        }
    }
}
