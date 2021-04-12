using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeScript : MonoBehaviour
{
    private Material myMat;
    bool active;

    private void Start()
    {
        myMat = GetComponent<Renderer>().material;
    }

    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space))
        {
            active = !active;
        }

        if(active==true)
        {
            //myMat.SetFloat("_edgeIntensity", 1.0f);
            Shader.SetGlobalFloat("_rainIntensity", 1.0f);
        }
        else
        {
            //myMat.SetFloat("_edgeIntensity", 0.0f);
            Shader.SetGlobalFloat("_rainIntensity", 0.0f);
        }
        
    }
}
