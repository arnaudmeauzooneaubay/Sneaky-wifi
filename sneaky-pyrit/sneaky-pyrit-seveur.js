// Written by Arnaud Meauzoone april 2017

var express = require('express');
var fs = require('fs');
var http = require("http");

var PORT = 8081;
var FILE_PATH = __dirname + "/wpa.cap";

var app = express();


app.post('/upload', function(req, res) {
  req.on('data', function(data) {
    fs.writeFile(FILE_PATH, data);
    console.log("");
    console.log("Got somethings !!!");
    console.log("length : ", data.length);
  })

  req.on('end', function() {
    console.log("file uploaded. Let's rock !!");
    res.sendStatus(200)
  })
})

app.post('/command', function(req, res) {
  var exec = require('child_process').exec;
  var Process;

  req.on('data', function(data) {
    console.log("Client asking: pyrit " + data );
    Process = exec('pyrit ' + data);

    Process.stdout.on('data', function(data) {
        res.write(data)
    })
    Process.stdout.on('end', function() {
      console.log("Process ended");
      res.end("")
    })
  })
})

app.get("/list_cores", function(req, res) {
var exec = require('child_process').exec;
var Process = exec('pyrit benchmark');

Process.stdout.on('data', function(data) {
    res.write(data)
})
Process.stdout.on('end', function() {
  console.log("Process ended");
    res.end("")
})
})

app.listen(PORT);
console.log("The server has been started !!");
console.log("Send a wpa.cap file at ip:8081/upload");
console.log("And we will crack it !!");
