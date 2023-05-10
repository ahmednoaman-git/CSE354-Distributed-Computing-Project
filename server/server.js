const express = require('express');
const { Pool, Query } = require('pg');
const cors = require('cors')
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: false}))

const pool = new Pool({
  user: 'ahmed_noaman',
  host: 'database-1.cr99gf9eqcuq.eu-north-1.rds.amazonaws.com',
  database: 'postgres',
  password: 'A89894331n',
  port: 5432,
});


app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.get('/players', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM game_schema."Players"');
  res.json(rows);
  console.log('hello')
  console.log(req.body)
});

app.get('/sessions', async (req, res) => {
  const active = req.headers.active
  console.log(active)
  const activeQueryClause = active ? 'WHERE array_length("playersID", 1) IS NULL' : ''
  const { rows } = await pool.query(`
    SELECT * 
    FROM game_schema."Sessions" 
    ${activeQueryClause};
  `)
  res.json(rows)
});

app.get('/chat', async (req, res) => {
  const sessionID = req.headers.sessionid;
  console.log(sessionID)
  const { rows: chatRows } = await pool.query(`
    SELECT *
    FROM game_schema."Chats"
    WHERE "sessionID" = '${sessionID}'
  `);

  if (chatRows.length === 0) {
    return res.status(404).json({ error: 'Chat not found' });
  }

  res.json(chatRows[0].chatID)
  console.log(chatRows[0].chatID)
})


app.get('/messages', async (req, res) => {
  const sessionID = req.headers.sessionid;
  console.log(sessionID)
  const { rows: chatRows } = await pool.query(`
    SELECT *
    FROM game_schema."Chats"
    WHERE "sessionID" = '${sessionID}'
  `);
  console.log(chatRows)

  if (chatRows.length === 0) {
    return res.status(404).json({ error: 'Chat not found' });
  }

  const chat = chatRows[0];
  console.log(chat)
  const messagesID = chat.messagesID;

  const { rows: messageRows } = await pool.query(`
    SELECT *
    FROM game_schema."Messages"
    WHERE "messageID" = ANY($1)
  `, [messagesID]);

  res.json(messageRows);
  console.log(messageRows)
});

app.post('/addplayer', async (req, res) => {
  const { playerID, username, password, imageUrl } = req.body
  const query = `
    INSERT INTO 
      game_schema."Players" 
    ("playerID", "username", "password", "imageUrl")
    VALUES
      ('${playerID}', '${username}', '${password}', '${imageUrl}')
  `
});

app.post('/addsession', async (req, res) => {
  const {sessionID, start, sessionName, private, password, numberOfPlayers, numberOfLaps, chatID} = req.body
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
  `
  console.log(query)
  try {
    await pool.query(query);
    res.status(200).send('Session added successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error adding session');
  }
});

app.post('/addmessage', async (req, res) => {
  const { messageID, chatID, from, to, private, content, time } = req.body

  toParsed = to == null ? 'NULL' : `'${to}'`

  const query = `
    INSERT INTO
      game_schema."Messages"
    ("messageID", "chatID", "from", "to", "private", "content", "time")
    VALUES
      ('${messageID}', '${chatID}', '${from}', ${toParsed}, ${private}, '${content}', '${time}');

    UPDATE game_schema."Chats"
    SET "messagesID" = "messagesID" || '${messageID}'::UUID
    WHERE "chatID" = '${chatID}';
  `

  console.log(query)

  try {
    await pool.query(query);
    res.status(200).send('Message added successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error adding message');
  }
})

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
