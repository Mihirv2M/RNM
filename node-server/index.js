const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const dbUrl = 'mongodb+srv://mihir:Mihir1234@cluster0.glpnl5r.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

main().catch(err => console.log('Error connecting to database:', err));

async function main() {
    await mongoose.connect(dbUrl, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
    });
    console.log('Database connected');
}

const userSchema = new mongoose.Schema({
    username: String,
    password: String,
});

const User = mongoose.model('User', userSchema);

const server = express();

server.use(cors());
server.use(bodyParser.json());

// Root route: returns "Hello World"
server.get('/', (req, res) => {
    res.status(200).send('Hello World');
});

// Health check route for ECS
server.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy' });
});

// CRUD - Create
server.post('/health/demo', async (req, res) => {
    try {
        const user = new User({
            username: req.body.username,
            password: req.body.password,
        });
        const doc = await user.save();
        console.log('User created:', doc);
        res.json(doc);
    } catch (err) {
        console.error('Error creating user:', err);
        res.status(500).json({ error: 'Failed to create user' });
    }
});

// Retrieve all users
server.get('/test', async (req, res) => {
    try {
        const docs = await User.find({});
        res.json(docs);
    } catch (err) {
        console.error('Error retrieving users:', err);
        res.status(500).json({ error: 'Failed to retrieve users' });
    }
});

// Handle undefined routes (404)
server.use((req, res) => {
    res.status(404).json({ error: 'Not Found' });
});

server.listen(8080, () => {
    console.log('Server started on port 8080');
});
