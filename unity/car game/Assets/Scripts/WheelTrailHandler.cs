using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WheelTrailHandler : MonoBehaviour
{
    CarPhysics carController;
    TrailRenderer trailRenderer;

    void Awake() {
        carController = GetComponentInParent<CarPhysics>();
        trailRenderer = GetComponent<TrailRenderer>();
        trailRenderer.emitting = false;
    }
    
    void Start()
    {
        
    }

    void Update()
    {
        if (carController.IsTireScreeching(out float lateralVelocity, out bool isBraking)) {
            trailRenderer.emitting = true;
        } else {
            trailRenderer.emitting = false;
        }
    }
}
