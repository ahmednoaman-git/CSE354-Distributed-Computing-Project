const express = require('express');
const { Pool } = require('pg');
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

app.post('/addplayer', async (req, res) => {
  const { playerID, username, password, imageUrl } = req.body
  const query = `
  INSERT INTO game_schema."Players" ("playerID", "username", "password", "imageUrl")
  VALUES
   ('${playerID}', '${username}', '${password}', '${imageUrl}')
  `
  console.log(query)
  
  try {
    await pool.query(query);
    res.status(200).send('Player added successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error adding player');
  }
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
