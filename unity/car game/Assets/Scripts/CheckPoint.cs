using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{
    public bool isFinishLine = false;
    public int checkPointNumber = 1;

    void Start()
    {
        checkPointNumber = int.Parse(gameObject.name);
    }
}