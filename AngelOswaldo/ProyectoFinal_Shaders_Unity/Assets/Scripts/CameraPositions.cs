using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraPositions : MonoBehaviour
{
    public List<Transform> cameraPositions;
    public Transform myCamera;
    public int actualIndex = 0;

    private void Update()
    {

        if (Input.GetKeyDown(KeyCode.A))
        {
            GoBack();
        }
        else if (Input.GetKeyDown(KeyCode.D))
        {
            GoFront();
        }

    }

    private void GoBack()
    {
        actualIndex -= 1;
        if(actualIndex<=0)
        {
            actualIndex = cameraPositions.Count - 1;
        }
        myCamera.position = cameraPositions[actualIndex].position;
        myCamera.rotation = cameraPositions[actualIndex].rotation;
    }

    private void GoFront()
    {
        actualIndex += 1;
        if (actualIndex >= cameraPositions.Count)
        {
            actualIndex = 0;
        }
        myCamera.position = cameraPositions[actualIndex].position;
        myCamera.rotation = cameraPositions[actualIndex].rotation;
    }

}
