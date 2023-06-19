using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class CarLapCounter : MonoBehaviour
{
    int passedCheckPointNumber = 0;
    float timeAtLastPassedCheckPoint = 0; 
    int numberOfPassedCheckPoints = 0;
    int lapsCompleted = 0;
    const int lapsToComplete = 2;
    bool raceComplete = false;
    int carPosition = 0;

    public event Action<CarLapCounter> OnPassCheckPoint;

    public void SetCarPosition(int position) {
        carPosition = position;
    }

    public int GetNumberOfCheckPointsPassed() {
        return numberOfPassedCheckPoints;
    }

    public float GetTimeAtLastCheckPoint() {
        return timeAtLastPassedCheckPoint;
    }

    void OnTriggerEnter2D(Collider2D collider2D)
    {
        if (collider2D.CompareTag("CheckPoint")) {
            if (raceComplete) {
                return;
            }

            CheckPoint checkPoint = collider2D.GetComponent<CheckPoint>();

            if (passedCheckPointNumber + 1 == checkPoint.checkPointNumber) {
                passedCheckPointNumber = checkPoint.checkPointNumber;
                numberOfPassedCheckPoints++;
                timeAtLastPassedCheckPoint = Time.time;

                if (checkPoint.isFinishLine) {
                    passedCheckPointNumber = 0;
                    lapsCompleted++;

                    if (lapsCompleted >= lapsToComplete) {
                        raceComplete = true;
                    }
                }

                OnPassCheckPoint?.Invoke(this);
            }
        }
    }
}
