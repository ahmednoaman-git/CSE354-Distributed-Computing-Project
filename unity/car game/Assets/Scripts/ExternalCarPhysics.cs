using System;
using System.Collections;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using UnityEngine;

public class ExternalCarPhysics : MonoBehaviour
{
    float accelerationInput;
    Rigidbody2D carRigidBody;
    int frame = 0;
    // Start is called before the first frame update
    void Start()
    {
        carRigidBody = GetComponent<Rigidbody2D>();
    }

    void Update()
    {
        // frame++;
        // if (frame == 100) {
        //     moveCar($@"
        //         {{
        //             ""accelerationInput"": 1,
        //             ""position"": {{
        //                 ""x"": 4,
        //                 ""y"": 4
        //             }},
        //             ""velocity"": {{
        //                 ""x"": 2,
        //                 ""y"": 2
        //             }},
        //             ""rotation"": 60
        //         }}
        //     ");
        // }
    }

    void FixedUpdate()
    {
    }
    float GetLateralVelocity() {
        return Vector2.Dot(transform.right, carRigidBody.velocity);
    }

    public bool IsTireScreeching(out float lateralVelocity, out bool isBraking) {
        lateralVelocity = Vector2.Dot(transform.right, carRigidBody.velocity);
        float longitudinalVelocity = Vector2.Dot(transform.up, carRigidBody.velocity);
        isBraking = false;

        if (accelerationInput < 0 && longitudinalVelocity > 0) {
            isBraking = true;
            return true;
        }

        if (MathF.Abs(lateralVelocity) > 4.0f) {
            return true;
        }

        return false;
    }

    public void updateCarState(string state) {
        Debug.Log(state);
        JObject parsedState = JObject.Parse(state);

        accelerationInput = (float)parsedState["accelerationInput"];
        transform.position = new Vector3((float)parsedState["position"]["x"], (float)parsedState["position"]["y"], 0f);
        carRigidBody.velocity = new Vector2((float)parsedState["velocity"]["x"], (float)parsedState["velocity"]["y"]);
        carRigidBody.drag = (float)parsedState["drag"];
        carRigidBody.rotation = (float)parsedState["rotation"];
    }
}
