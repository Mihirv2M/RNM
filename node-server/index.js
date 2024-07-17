const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
//const admin= process.env.MONGO_INITDB_ROOT_USERNAME;
//const password = process.env.MONGO_INITDB_ROOT_PASSWORD;
main().catch(err => console.log(err));

async function main() {
    await mongoose.connect("mongodb://admin:password@13.51.237.129:27017/");
    // await mongoose.connect("mongodb://${process.env.MONGO_INITDB_ROOT_USERNAME}:${process.env.MONGO_INITDB_ROOT_PASSWORD}@mongodb:27017/");
    console.log('db connected')
}
const userSchema = new mongoose.Schema({
    username: String,
    password: String
});

const User = mongoose.model('User', userSchema);




const server = express();

server.use(cors());
server.use(bodyParser.json());

// CRUD - Create
server.post('/demo',async (req,res)=>{
     
    let user = new User();
    user.username = req.body.username;
    user.password = req.body.password;
    const doc = await user.save();

    console.log(doc);
    res.json(doc);
})

server.get('/test',async (req,res)=>{
    const docs = await User.find({});
    res.json(docs)
})

server.listen(8080,()=>{
    console.log('server started')
})
