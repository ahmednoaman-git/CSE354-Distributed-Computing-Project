using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using FlutterUnityIntegration;
using Newtonsoft.Json;

public class PositionHandler : MonoBehaviour
{
    public List<CarLapCounter> carLapCounters = new List<CarLapCounter>();
    
    void init() {
        CarLapCounter[] carLapCounterArray = FindObjectsOfType<CarLapCounter>();
        Debug.Log($"Length of carlapcounters: {carLapCounterArray.Length}");

        carLapCounters = carLapCounterArray.ToList<CarLapCounter>();
        
        foreach (CarLapCounter lapCounters in carLapCounters) {
            lapCounters.OnPassCheckPoint += OnPassCheckPoint;
        }
    }

    void OnPassCheckPoint(CarLapCounter carLapCounter)
    {
        carLapCounters = carLapCounters.OrderByDescending(s => s.GetNumberOfCheckPointsPassed()).ThenBy(s => s.GetTimeAtLastCheckPoint()).ToList();
        int carPosition = carLapCounters.IndexOf(carLapCounter) + 1;
        carLapCounter.SetCarPosition(carPosition);

        Dictionary<string, int> carPositions = new Dictionary<string, int>();
        foreach (CarLapCounter _carLapCounter in carLapCounters)
        {   
            string carName = _carLapCounter.gameObject.name;
            int _carPosition = _carLapCounter.carPosition;
            carPositions.Add(carName, _carPosition);
        }
        string json = JsonConvert.SerializeObject(carPositions);
        UnityMessageManager.Instance.SendMessageToFlutter(json);
    }
}


