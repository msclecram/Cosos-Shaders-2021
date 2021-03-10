using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeShift : MonoBehaviour
{
    public bool isEdgeActive = false;
    Material material;
    // Start is called before the first frame update
    void Start()
    {
        material = GetComponent<Renderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        if(isEdgeActive)
            material.SetFloat("_edgeIntesity",1.0f);
        else
            material.SetFloat("_edgeIntesity", 0.0f);
    }
}
