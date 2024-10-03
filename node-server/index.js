
//require('dotenv').config(); // Load environment variables

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const dbUrl = 'mongodb+srv://mihir:Mihir1234@cluster0.glpnl5r.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';


// Connect to MongoDB
async function main() {
    try {
        await mongoose.connect(dbUrl, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
            // useCreateIndex: true, // Uncomment if needed
            // useFindAndModify: false, // Uncomment if needed
        });
        console.log('Database connected');
    } catch (err) {
        console.error('Error connecting to database:', err);
        process.exit(1); // Exit process with failure
    }
}

main();

// Define User schema and model
const userSchema = new mongoose.Schema({
    username: { type: String, required: true },
    password: { type: String, required: true },
});

const User = mongoose.model('User', userSchema);

// Initialize Express app
const server = express();

// Middleware
server.use(cors());
server.use(bodyParser.json());

// Routes
// Root route
server.get('/', (req, res) => {
    res.status(200).send('Hello World');
});

// Health check route
server.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy' });
});

// Create user
server.post('/health/demo', async (req, res) => {
    const { username, password } = req.body;

    // Basic validation
    if (!username || !password) {
        return res.status(400).json({ error: 'Username and password are required' });
    }

    try {
        const user = new User({ username, password });
        const doc = await user.save();
        console.log('User created:', doc);
        res.status(201).json(doc);
    } catch (err) {
        console.error('Error creating user:', err);
        res.status(500).json({ error: 'Failed to create user' });
    }
});

// Retrieve all users
server.get('/test', async (req, res) => {
    try {
        const docs = await User.find({});
        res.status(200).json(docs);
    } catch (err) {
        console.error('Error retrieving users:', err);
        res.status(500).json({ error: 'Failed to retrieve users' });
    }
});

// Handle undefined routes
server.use((req, res) => {
    res.status(404).json({ error: 'Not Found' });
});

// Start server
const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`);
});
