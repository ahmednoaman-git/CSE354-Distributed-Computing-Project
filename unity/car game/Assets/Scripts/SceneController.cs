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
        // loadGameSettings($@"{{
        //     ""map"":1,
        //     ""players"":[
        //         {{
        //             ""playerID"":""826ee65a-71d6-4b4f-95b3-d98731e2295d"",
        //             ""sessionID"":""e0705f4b-1b1f-4817-9218-0821aa7c6eec"",
        //             ""isClientPlayer"":true,
        //             ""car"":""Cars/Green/car_green_3""
        //         }}
        //     ]

        // }}");

        // // Add a`SpriteRenderer` component to the game object
        // 
        // 

        // // Add a Rigidbody2D component to the game object
        // 

        // // Add a BoxCollider2D component to the game object
        // 

        // // Add the CarPhysics script to the game object
        // 
    }

    public void loadGameSettings(string gameSettings) {
        // UnityMessageManager.Instance.SendMessageToFlutter(gameSettings);

        JObject parsedInit = JObject.Parse(gameSettings);
        
        JArray players = (JArray)parsedInit["players"];
        int i = 0;
        foreach (JObject player in players)
        {
            string playerID = (string)player["playerID"];
            bool isClientPlayer = (bool)player["isClientPlayer"];
            string carSpritePath = (string)player["car"];

            float positionX = i;
            float positionY = 0;
            Vector3 initialPosition = new Vector3(positionX, positionY, 0f);

            GameObject carObject = new GameObject(playerID);
            
            carObject.transform.position = initialPosition;
            carObject.transform.localScale = new Vector3(1.64f, 1.64f, 1.64f);

            SpriteRenderer spriteRenderer = carObject.AddComponent<SpriteRenderer>();
            spriteRenderer.sprite = Resources.Load<Sprite>(carSpritePath);

            Rigidbody2D rigidbody2D = carObject.AddComponent<Rigidbody2D>();

            BoxCollider2D boxCollider2D = carObject.AddComponent<BoxCollider2D>();

            if (isClientPlayer) {
                CarPhysics carPhysics = carObject.AddComponent<CarPhysics>();
                CarInput carInput = carObject.AddComponent<CarInput>();
            } else {
                ExternalCarPhysics externalCarPhysics = carObject.AddComponent<ExternalCarPhysics>();
            }

            i = i + 3;
        }
    }
}