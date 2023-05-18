using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CarPhysics : MonoBehaviour
{
    [Header("Car Settings")]
    public float accelerationRate = 5f;
    public float rotationRate = 3.5f;
    public float rightVelocityReductionRate = 0.95f;
    public float dragRate = 3f;
    public float maxSpeed = 20f;
    float accelerationInput = 0f;
    float steeringInput = 0f;
    float rotationAngle = 0f;
    float velocityUp = 0f;

    Rigidbody2D carRigidBody;
    void Start()
    {
        carRigidBody = GetComponent<Rigidbody2D>();
    }

    void Update()
    {
    }

    void FixedUpdate()
    {
        ForwardMomentum();
        KillOrthogonalVelocity();
        Steer();
    }

    private void ForwardMomentum()
    {
        velocityUp = Vector2.Dot(transform.up, carRigidBody.velocity);
        if ((velocityUp > maxSpeed && accelerationInput > 0) ||
            (velocityUp < -maxSpeed * 0.5f && accelerationInput < 0) ||
            (carRigidBody.velocity.sqrMagnitude > maxSpeed * maxSpeed && accelerationInput > 0))
        {
            return;
        }


        if (accelerationInput == 0)
        {
            carRigidBody.drag = Mathf.Lerp(carRigidBody.drag, dragRate, Time.fixedDeltaTime * 3);
        } else
        {
            carRigidBody.drag = 0.2f;
        }

        Vector2 forceVector = transform.up * accelerationInput * accelerationRate;
        carRigidBody.AddForce(forceVector, ForceMode2D.Force);
    }

    private void Steer()
    {
        float minThresholdToTurn = carRigidBody.velocity.magnitude / 8f;
        minThresholdToTurn = Mathf.Clamp01(minThresholdToTurn);

        rotationAngle -= steeringInput * rotationRate * minThresholdToTurn;
        carRigidBody.MoveRotation(rotationAngle);
    }

    private void KillOrthogonalVelocity()
    {
        Vector2 forwardVelocity = transform.up * Vector2.Dot(carRigidBody.velocity, transform.up);
        Vector2 rightVelocity = transform.right * Vector2.Dot(carRigidBody.velocity, transform.right);

        carRigidBody.velocity = forwardVelocity + rightVelocity * rightVelocityReductionRate;
    }

    public void SetInputVector(Vector2 inputVector)
    {
        accelerationInput = inputVector.y;
        steeringInput = inputVector.x;
    }

}