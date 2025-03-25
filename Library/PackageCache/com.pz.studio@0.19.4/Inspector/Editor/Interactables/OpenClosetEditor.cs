#if HR_LUA_GENERATED

using UnityEditor;
using UnityEngine;
using Highrise.Lua.Generated;
using Highrise;

[CustomEditor(typeof(OpenClosetObject)), CanEditMultipleObjects]
public class OpenClosetObjectEditor : Editor
{
    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUI.BeginDisabledGroup(true);
        EditorGUILayout.PropertyField(serializedObject.FindProperty("_script"));
        EditorGUI.EndDisabledGroup();

        EditorGUILayout.PropertyField(serializedObject.FindProperty("_includePlayerClosetInventory"));

        SerializedProperty clothingCollectionsProp = serializedObject.FindProperty("_includedClothingCollections");
        EditorGUILayout.PropertyField(clothingCollectionsProp);

        EditorGUILayout.Space();
        if (GUILayout.Button("Add Additional Clothing"))
        {
            foreach (Object targetObject in targets)
            {
                OpenClosetObject openClosetTarget = targetObject as OpenClosetObject;
                if (openClosetTarget != null)
                {
                    CreateClothingCollection(openClosetTarget, "ClosetClothingCollection", true);
                }
            }
        }
        EditorGUILayout.Space(24);

        SerializedProperty useCustomStartingOutfitProp = serializedObject.FindProperty("_useCustomStartingOutfit");
        EditorGUILayout.PropertyField(useCustomStartingOutfitProp);

        if (useCustomStartingOutfitProp.boolValue)
        {
            SerializedProperty startingClosetOutfitProp = serializedObject.FindProperty("_startingClosetOutfit");
            EditorGUILayout.PropertyField(startingClosetOutfitProp);

            if (startingClosetOutfitProp.objectReferenceValue == null)
            {
                EditorGUILayout.Space();
                if (GUILayout.Button("Create Starting Outfit"))
                {
                    foreach (Object targetObject in targets)
                    {
                        OpenClosetObject openClosetTarget = targetObject as OpenClosetObject;
                        if (openClosetTarget != null)
                        {
                            CreateClothingCollection(openClosetTarget, "StartingOutfitClothingCollection", false);
                        }
                    }
                }
                EditorGUILayout.Space();
            }
        }

        EditorGUILayout.PropertyField(serializedObject.FindProperty("_defaultToFirstTab"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("_closetTitle"));
        EditorGUILayout.PropertyField(serializedObject.FindProperty("_saveButtonText"));

        serializedObject.ApplyModifiedProperties();
    }

    private void CreateClothingCollection(OpenClosetObject closetTarget, string name, bool array)
    {
        string path = "Assets/" + name + ".asset";
        var collection = ScriptableObject.CreateInstance<ClothingCollection>();
        //find unique name
        path = AssetDatabase.GenerateUniqueAssetPath(path);
        AssetDatabase.CreateAsset(collection, path);
        if (array)
        {
            closetTarget._includedClothingCollections.Add(collection);
        }
        else
        {
            closetTarget._startingClosetOutfit = collection;
        }
        serializedObject.ApplyModifiedProperties();
        UnityEditor.EditorUtility.SetDirty(closetTarget);

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        Selection.activeObject = collection;
        EditorGUIUtility.PingObject(collection);
    }
}
#endif