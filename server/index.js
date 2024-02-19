const express = require("express");
const mongoose = require("mongoose");
const { Server } = require("socket.io");
const http = require("http");

const app = express();
const server = http.createServer(app);
const io = new Server(server);

mongoose
  .connect("mongodb://localhost:27017/mydatabase")
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error("Could not connect to MongoDB"));

app.get("/", (req, res) => {
  res.send("<h1>Hello world</h1>");
});

io.on("connection", (socket) => {
  console.log("a user connected");

  socket.on("stamp", () => {
    console.log("stamp");
    socket.emit("stamp_response", "Stamp recieved");
  });

  socket.on("live", () => {
    console.log("live");
    socket.emit("live_response", "Live recieved");
  });
});

io.on("test", () => {
  console.log("tested");
});

server.listen(3000, () => {
  console.log("listening on *:3000");
});
