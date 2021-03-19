using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostScriptsPor : MonoBehaviour
{
    public Material mat;
    
    void Start()
    {
        
    }

    void Update()
    {
        
    }
    
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
    }
}
