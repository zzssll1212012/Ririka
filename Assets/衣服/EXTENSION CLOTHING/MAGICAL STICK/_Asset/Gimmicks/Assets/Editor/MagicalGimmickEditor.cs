using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(EXTENSIONCLOTHING.MSCG.MagicalGimmickMain))]
public class MagicalGimmickEditor : Editor
{
    private Texture2D logo;
    private Texture2D scriptIcon;
    private bool showMagicalStickOptions = false;

    private void OnEnable()
    {
        logo = Resources.Load<Texture2D>("logo");
        scriptIcon = Resources.Load<Texture2D>("Icon");
        if (scriptIcon != null)
        {
            MonoScript script = MonoScript.FromMonoBehaviour((MonoBehaviour)target);
            if (script != null)
            {
                EditorGUIUtility.SetIconForObject(script, scriptIcon);
            }
        }
    }

    public override void OnInspectorGUI()
    {
        if (logo != null)
        {
            GUILayout.BeginHorizontal();

            float aspectRatio = (float)logo.width / logo.height;
            float maxWidth = EditorGUIUtility.currentViewWidth;
            float width = Mathf.Min(maxWidth, logo.width);
            float height = width / aspectRatio;

            GUILayout.FlexibleSpace();

            GUILayout.Label(logo, GUILayout.Width(width), GUILayout.Height(height));

            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
        }

        serializedObject.Update();

        Rect dropArea = GUILayoutUtility.GetRect(0f, 120f, GUILayout.ExpandWidth(true));
        GUIStyle dropAreaStyle = new GUIStyle(GUI.skin.box)
        {
            alignment = TextAnchor.MiddleCenter,
            fontSize = 14,
            fontStyle = FontStyle.Bold
        };

        GUI.Box(dropArea, "元々着ている衣装や髪などを追加\nAdd the outfit, hair, etc. you are already wearing HERE", dropAreaStyle);

        Event evt = Event.current;
        switch (evt.type)
        {
            case EventType.DragUpdated:
            case EventType.DragPerform:
                if (!dropArea.Contains(evt.mousePosition))
                    break;

                DragAndDrop.visualMode = DragAndDropVisualMode.Copy;

                if (evt.type == EventType.DragPerform)
                {
                    DragAndDrop.AcceptDrag();

                    SerializedProperty costumeObjects = serializedObject.FindProperty("costumeObjects");

                    foreach (Object draggedObject in DragAndDrop.objectReferences)
                    {
                        GameObject go = draggedObject as GameObject;
                        if (go != null)
                        {
                            bool alreadyExists = false;
                            for (int i = 0; i < costumeObjects.arraySize; i++)
                            {
                                if (costumeObjects.GetArrayElementAtIndex(i).objectReferenceValue == go)
                                {
                                    alreadyExists = true;
                                    break;
                                }
                            }

                            if (!alreadyExists)
                            {
                                costumeObjects.InsertArrayElementAtIndex(costumeObjects.arraySize);
                                costumeObjects.GetArrayElementAtIndex(costumeObjects.arraySize - 1).objectReferenceValue = go;
                            }
                        }
                    }
                }
                Event.current.Use();
                break;
        }

        EditorGUILayout.Space();

        SerializedProperty costumeObjectsList = serializedObject.FindProperty("costumeObjects");

        for (int i = costumeObjectsList.arraySize - 1; i >= 0; i--)
        {
            if (costumeObjectsList.GetArrayElementAtIndex(i).objectReferenceValue == null)
            {
                costumeObjectsList.DeleteArrayElementAtIndex(i);
            }
        }

        for (int i = 0; i < costumeObjectsList.arraySize; i++)
        {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PropertyField(costumeObjectsList.GetArrayElementAtIndex(i), new GUIContent($"Element {i}"), true);

            if (GUILayout.Button("Delete", GUILayout.Width(60)))
            {
                costumeObjectsList.DeleteArrayElementAtIndex(i);
            }

            EditorGUILayout.EndHorizontal();
        }

        if (GUILayout.Button("All Delete"))
        {
            costumeObjectsList.ClearArray();
        }

        EditorGUILayout.Space(50);

        Rect dropAreaChanged = GUILayoutUtility.GetRect(0.0f, 50.0f, GUILayout.ExpandWidth(true));
        GUI.Box(dropAreaChanged, "変身後の髪やアクセサリーなどを追加\nAdd the outfit, hair, etc. after transformation HERE", dropAreaStyle);

        switch (evt.type)
        {
            case EventType.DragUpdated:
            case EventType.DragPerform:
                if (!dropAreaChanged.Contains(evt.mousePosition))
                    break;

                DragAndDrop.visualMode = DragAndDropVisualMode.Copy;

                if (evt.type == EventType.DragPerform)
                {
                    DragAndDrop.AcceptDrag();

                    SerializedProperty changedManualWear = serializedObject.FindProperty("changedManualWear");

                    foreach (Object draggedObject in DragAndDrop.objectReferences)
                    {
                        GameObject go = draggedObject as GameObject;
                        if (go != null)
                        {
                            bool alreadyExists = false;
                            for (int i = 0; i < changedManualWear.arraySize; i++)
                            {
                                if (changedManualWear.GetArrayElementAtIndex(i).objectReferenceValue == go)
                                {
                                    alreadyExists = true;
                                    break;
                                }
                            }

                            if (!alreadyExists)
                            {
                                changedManualWear.InsertArrayElementAtIndex(changedManualWear.arraySize);
                                changedManualWear.GetArrayElementAtIndex(changedManualWear.arraySize - 1).objectReferenceValue = go;
                            }
                        }
                    }
                }
                Event.current.Use();
                break;
        }

        EditorGUILayout.Space();

        SerializedProperty changedManualWearList = serializedObject.FindProperty("changedManualWear");

        for (int i = changedManualWearList.arraySize - 1; i >= 0; i--)
        {
            if (changedManualWearList.GetArrayElementAtIndex(i).objectReferenceValue == null)
            {
                changedManualWearList.DeleteArrayElementAtIndex(i);
            }
        }

        for (int i = 0; i < changedManualWearList.arraySize; i++)
        {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PropertyField(changedManualWearList.GetArrayElementAtIndex(i), new GUIContent($"Element {i}"), true);

            if (GUILayout.Button("Delete", GUILayout.Width(60)))
            {
                changedManualWearList.DeleteArrayElementAtIndex(i);
            }

            EditorGUILayout.EndHorizontal();
        }

        if (GUILayout.Button("All Delete"))
        {
            changedManualWearList.ClearArray();
        }

        EditorGUILayout.Space(50);

        showMagicalStickOptions = EditorGUILayout.Foldout(showMagicalStickOptions, "Magical★Stickオプション", true);
        if (showMagicalStickOptions)
        {
            EditorGUILayout.PropertyField(serializedObject.FindProperty("magicalStickObject"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("hideAnimationClip"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("showAnimationClip"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("layerControlClip"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("shapekeyAnimationClip"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("particleSystemPrefab"), new GUIContent("Particle System Prefab"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("particleTree"), new GUIContent("Particle System Tree"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("magicalHairHeadBone"), new GUIContent("Magical Hair Head Bone"));
        }

        serializedObject.ApplyModifiedProperties();
    }
}