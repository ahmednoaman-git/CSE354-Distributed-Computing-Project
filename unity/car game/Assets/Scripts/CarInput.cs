using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CarInput : MonoBehaviour
{
    CarPhysics carPhysics;

    void Awake()
    {
        carPhysics = GetComponent<CarPhysics>();
    }

    void Update()
    {
        Vector2 inputVector = Vector2.zero;

        inputVector.x = Input.GetAxis("Horizontal");
        inputVector.y = Input.GetAxis("Vertical");

        carPhysics.SetInputVector(inputVector);
    }
}
