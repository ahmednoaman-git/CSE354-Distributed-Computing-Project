const express = require("express");
const { Pool, Query } = require("pg");
const cors = require("cors");
const bodyParser = require("body-parser");
const socketIO = require("socket.io");
const util = require("util");

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

server = app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});

const pool = new Pool({
  user: "ahmed_noaman",
  host: "database-1.cr99gf9eqcuq.eu-north-1.rds.amazonaws.com",
  database: "postgres",
  password: "A89894331n",
  port: 5432,
});

const io = socketIO(server);

//////////////////
//// - SOCKET - ////
//////////////////

var players = {};
var sessions = {};
var sessionStates = {};

var n = 0;

io.on("connection", (player) => {
  console.log(`Player setup socket connection with sid: ${player.id}`);

  player.on("joinChat", (room) => {
    console.log(`Player joined chatroom ${room}`);
    player.join(room);
  });

  player.on("joinSession", (playerData) => {
    playerData = JSON.parse(playerData);
    console.log(`Player joined session ${playerData.sessionID}`);

    // if player is already in the session
    if (
      sessions[playerData.sessionID] !== undefined &&
      sessions[playerData.sessionID].players.includes(playerData.playerID)
    ) {
      io.to(player.id).emit(
        "sessionPlayers",
        sessions[playerData.sessionID]["players"]
      );
      return;
    }

    players[player.id] = playerData.playerID;
    console.log(players);
    player.join(playerData.sessionID);

    // if the session doesn't yet exist, create it in memory.
    if (sessions[playerData.sessionID] === undefined) {
      sessions[playerData.sessionID] = {
        leader: playerData.playerID,
        players: [playerData.playerID],
        state: "open",
      };

      // if it does exist, send to the connecting player the states of the current players in the session.
    } else {
      sessions[playerData.sessionID]["players"].push(playerData.playerID);

      for (let [playerID, state] of Object.entries(sessionStates)) {
        io.to(player.id).emit("sessionState", state);
      }
    }

    // give the connecting player the session info and send their info to the existing players.
    io.to(player.id).emit(
      "sessionLeader",
      sessions[playerData.sessionID]["leader"]
    );
    io.to(player.id).emit(
      "sessionPlayers",
      sessions[playerData.sessionID]["players"]
    );
    player.to(playerData.sessionID).emit("playerJoined", playerData.playerID);

    console.log(`\nPlayer joined session successfully.\n- Sessions:`);
    console.log(sessions);
  });

  player.on("joinGame", (playerData) => {
    playerData = JSON.parse(playerData);
    player.join(playerData.sessionID);
    players[playerData.playerID] = playerData;
  });

  player.on("message", (data) => {
    data = JSON.parse(data);
    console.log("\nMessage recieved successfully.\n- Message:");
    console.log(data);
    player.in(data.chatID).emit("message", JSON.stringify(data));
  });

  player.on("sessionState", (state) => {
    sessionStates[state.playerID] = state;
    console.log(`\nRegistered player ${state.playerID} state:`);
    console.log("----------------------------------------\n- States:");
    console.log(sessionStates);
    console.log("----------------------------------------");
    player.to(state.sessionID).emit("sessionState", state);
  });

  player.on("startGame", (gameSettings) => {
    console.log(gameSettings);
    console.log("STARTING");
    io.in(gameSettings.sessionID).emit("startGame", gameSettings);
    sessions[gameSettings.sessionID]["state"] = "running";
    sessions[gameSettings.sessionID]["gameSettings"] = gameSettings;
    let lastStates = {};
    for (let playerID of sessions[gameSettings.sessionID]["players"]) {
      lastStates[playerID] = {};
    }
    sessions[gameSettings.sessionID]["lastStates"] = lastStates;
    console.log(sessions);
  });

  player.on("carState", (state) => {
    n++;
    player.to(state.sessionID).emit("carState", state);
    sessions[state.sessionID]["lastStates"][state.playerID] = state;
    if (n % 60 === 0) {
      console.log("- Sessions after 60 emits");
      console.log(util.inspect(sessions, false, null, true));
    }
  });

  player.on("reconnectRequest", (data) => {
    console.log("Emitting reconnectionData");
    player.join(data.sessionID);

    console.log(data);
    io.to(player.id).emit("reconnectionData", {
      gameSettings: sessions[data.sessionID]["gameSettings"],
      lastState: sessions[data.sessionID]["lastStates"][data.playerID],
    });
  });

  player.on("disconnecting", () => {
    playerIDToRemove = players[player.id];
    console.log(`\n----Player ${playerIDToRemove} is disconnecting.----`);

    for (const sessionID in sessions) {
      const playerIDs = sessions[sessionID]["players"];
      const index = playerIDs.indexOf(playerIDToRemove);

      // remove player out of the list of players.
      if (index !== -1) {
        if (sessions[sessionID]["state"] !== "running") {
          playerIDs.splice(index, 1);
          io.to(sessionID).emit("playerDisconnected", playerIDToRemove);
          console.log(
            `- Removed player: ${playerIDToRemove} from session :${sessionID}`
          );

          // if the session is now empty delete it.
          if (playerIDs.length === 0) {
            console.log(`- Session is empty, deleting session: ${sessionID}`);
            sessions[sessionID] = null;
            delete sessions[sessionID];
          }
        }
      }

      // remove the player state.
      if (Object.keys(sessionStates).includes(playerIDToRemove)) {
        console.log(`- Deleting player session state: ${playerIDToRemove}`);
        sessionStates[playerIDToRemove] = null;
        delete sessionStates[playerIDToRemove];
      }

      // player.disconnect();

      console.log("\n------------Sessions Status:------------\n- Sessions:");
      console.log(sessions);
      console.log("----------------------------------------\n- States:");
      console.log(sessionStates);
      console.log("----------------------------------------");
    }
  });
});

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/players", async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM game_schema."Players"');
  res.json(rows);
});

app.get("/player", async (req, res) => {
  const playerID = req.headers.playerid;
  const { rows } = await pool.query(`
    SELECT * FROM game_schema."Players"
    WHERE "playerID" = '${playerID}'
  `);

  if (rows.length === 0) {
    return res.status(404);
  }

  res.json(rows[0]);
});

app.get("/sessions", async (req, res) => {
  const playerID = req.headers.playerid;

  const { rows } = await pool.query(`
    SELECT * 
    FROM game_schema."Sessions"
  `);

  for (let i = 0; i < rows.length; i++) {
    currentSession = sessions[rows[i]["sessionID"]];
    if (sessions[rows[i]["sessionID"]] !== undefined) {
      rows[i]["playersID"] = currentSession["players"];
      rows[i]["state"] = currentSession["state"];
      rows[i]["reconnectable"] =
        currentSession["players"].includes(playerID) &&
        currentSession["state"] === "running";
    }
  }

  res.json(rows);
});

app.get("/session", async (req, res) => {
  const sessionID = req.headers.sessionid;

  const { rowCount, rows } = await pool.query(`
    SELECT *
    FROM game_schema."Sessions"
    WHERE "sessionID" = '${sessionID}';
  `);

  if (rowCount == 1) {
    res.json(rows[0]);
  }
});

app.get("/chat", async (req, res) => {
  const sessionID = req.headers.sessionid;

  const { rows: chatRows } = await pool.query(`
    SELECT *
    FROM game_schema."Chats"
    WHERE "sessionID" = '${sessionID}'
  `);

  if (chatRows.length === 0) {
    return res.status(404).json({ error: "Chat not found" });
  }

  res.json(chatRows[0].chatID);
});

app.get("/messages", async (req, res) => {
  const sessionID = req.headers.sessionid;

  const { rows: chatRows } = await pool.query(`
    SELECT *
    FROM game_schema."Chats"
    WHERE "sessionID" = '${sessionID}'
  `);
  if (chatRows.length === 0) {
    return res.status(404).json({ error: "Chat not found" });
  }

  const chat = chatRows[0];
  const messagesID = chat.messagesID;

  const { rows: messageRows } = await pool.query(
    `
    SELECT m.*, p.username, p."imageUrl"
    FROM game_schema."Messages" m
    JOIN game_schema."Players" p ON m.from = p."playerID"
    WHERE m."messageID" = ANY($1);
  `,
    [messagesID]
  );

  res.json(messageRows);
});

app.post("/addplayer", async (req, res) => {
  const { playerID, username, password, imageUrl } = req.body; // {"key1": "value1"}

  const query = `
    INSERT INTO 
      game_schema."Players" 
    ("playerID", "username", "password", "imageUrl")
    VALUES
      ('${playerID}', '${username}', '${password}', '${imageUrl}')
  `;
});

app.post("/addsession", async (req, res) => {
  const {
    sessionID,
    start,
    sessionName,
    private,
    password,
    numberOfPlayers,
    numberOfLaps,
    chatID,
  } = req.body;

  const query = `
    INSERT INTO
      game_schema."Sessions"
    ("sessionID", "playersID", "start", "sessionName", "private", password, "numberOfPlayers", "numberOfLaps")
    VALUES
      ('${sessionID}', array[]::uuid[], '${start}', '${sessionName}',  ${private}, '${password}', ${numberOfPlayers}, ${numberOfLaps});
    
    INSERT INTO
      game_schema."Chats"
    ("chatID",  "sessionID", "messagesID")
    VALUES
      ('${chatID}', '${sessionID}', array[]::uuid[]);
  `;

  try {
    await pool.query(query);
    res.status(200).send("Session added successfully");

    const chatChannel = io.of(`/${chatID}`);
    chatChannel.on("connection", (socket) => {
      console.log(`New player connected to ${chatID}`);

      socket.on("message", (message) => {
        console.log(`Recieved a message on ${chatID}`);
        chatChannel.emit("message", message);
      });

      socket.on("disconnect", () => {
        console.log(`A player disconnected from channel ${chatID}`);
      });
    });
  } catch (error) {
    console.error(error);
    res.status(500).send("Error adding session");
  }
});

app.post("/addmessage", async (req, res) => {
  const { messageID, chatID, from, to, private, content, time } = req.body;

  toParsed = to == null ? "NULL" : `'${to}'`;

  const query = `
    INSERT INTO
      game_schema."Messages"
    ("messageID", "chatID", "from", "to", "private", "content", "time")
    VALUES
      ('${messageID}', '${chatID}', '${from}', ${toParsed}, ${private}, '${content}', '${time}');

    UPDATE game_schema."Chats"
    SET "messagesID" = "messagesID" || '${messageID}'::UUID
    WHERE "chatID" = '${chatID}';
  `;

  try {
    await pool.query(query);
    res.status(200).send("Message added successfully");
  } catch (error) {
    console.error(error);
    res.status(500).send("Error adding message");
  }
});
