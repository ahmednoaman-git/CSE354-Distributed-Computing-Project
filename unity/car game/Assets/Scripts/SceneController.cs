using UnityEngine;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using FlutterUnityIntegration;

public class SceneController : MonoBehaviour
{
    [Header("Prefabs")]
    public GameObject carPrefab;

    private int numberOfPlayers = 0;

    private void Start()
    {
        string recievedInit = $@"
            {{
                ""map"":1,
                ""players"":[
                    {{
                        ""playerID"":""826ee65a-71d6-4b4f-95b3-d98731e2295d"",
                        ""sessionID"":""e0705f4b-1b1f-4817-9218-0821aa7c6eec"",
                        ""isClientPlayer"":false,
                        ""car"":""Cars/Green/car_green_3""
                    }},
                    {{
                        ""playerID"":""b5ae9d74-a2a3-4468-982a-9d91f759007f"",
                        ""sessionID"":""e0705f4b-1b1f-4817-9218-0821aa7c6eec"",
                        ""isClientPlayer"":true,
                        ""car"":""Cars/Red/car_red_1""
                    }},
                    {{
                        ""playerID"":""247ca967-9d0e-4312-a02f-bd962dfb1e46"",
                        ""sessionID"":""e0705f4b-1b1f-4817-9218-0821aa7c6eec"",
                        ""isClientPlayer"":false,
                        ""car"":""Cars/Black/car_black_4""
                    }},
                    {{
                        ""playerID"":""932950e6-4e93-4c7d-aa8c-ee3468cf2b12"",
                        ""sessionID"":""e0705f4b-1b1f-4817-9218-0821aa7c6eec"",
                        ""isClientPlayer"":false,
                        ""car"":""Cars/Blue/car_blue_3""
                    }}
                ]
            }}
        ";

        UnityMessageManager.Instance.SendMessageToFlutter("SceneControllerInitialized");
        // loadGameSettings(recievedInit);
    }

    public void loadGameSettings(string gameSettings) {

        JObject parsedInit = JObject.Parse(gameSettings);
        
        JArray players = (JArray)parsedInit["players"];
        int i = 0;
        foreach (JObject player in players)
        {
            string playerID = (string)player["playerID"];
            bool isClientPlayer = (bool)player["isClientPlayer"];
            string carSpritePath = (string)player["car"];

            float positionX = 18.293f;
            float positionY = 8.324f - 0.876f * i;

            GameObject carObject = new GameObject(playerID);

            SpriteRenderer spriteRenderer = carObject.AddComponent<SpriteRenderer>();
            spriteRenderer.sprite = Resources.Load<Sprite>(carSpritePath);
            spriteRenderer.sortingLayerName = "Cars";

            Rigidbody2D rigidbody2D = carObject.AddComponent<Rigidbody2D>();
            rigidbody2D.rotation = 90;

            Vector3 initialPosition = new Vector3(positionX, positionY, 0f);
            carObject.transform.position = initialPosition;
            carObject.transform.localScale = new Vector3(1f, 1f, 1f);

            BoxCollider2D boxCollider2D = carObject.AddComponent<BoxCollider2D>();

            if (isClientPlayer) {
                CarPhysics carPhysics = carObject.AddComponent<CarPhysics>();
                CarInput carInput = carObject.AddComponent<CarInput>();
            } else {
                ExternalCarPhysics externalCarPhysics = carObject.AddComponent<ExternalCarPhysics>();
            }

            CarLapCounter carLapCounter = carObject.AddComponent<CarLapCounter>();
            Debug.Log("Init carlapcounter for:");
            Debug.Log(carLapCounter.gameObject.name);

            i++;
        }

        UnityMessageManager.Instance.SendMessageToFlutter("FinishedLoadingGameSettings");
    }
}