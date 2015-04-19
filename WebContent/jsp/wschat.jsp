<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="UTF-8" />
<title>Tomcat WebSocket Chat</title>
<script>
	var ws_uri = "ws://"+"<%=request.getServerName()%>"+":"+"<%=request.getServerPort()%>"+"<%=request.getContextPath()%>"+"/wschat";
	console.log("ws_uri:"+ws_uri);
	var ws = new WebSocket(ws_uri);
	ws.onopen = function() {};

	ws.onmessage = function(message) {
		document.getElementById("chatlog").textContent += message.data + "\n";
	};
	function postToServer() {
		ws.send(document.getElementById("msg").value);
		document.getElementById("msg").value = "";
	}
	function closeConnect() {
		ws.close();
	}
</script>
    </head>
    <body>
        <textarea id="chatlog" readonly="readonly" style="resize:vertical;" rows="10"></textarea><br /><br />
        <input id="msg" type="text" />
        <button type="submit" id="sendButton" onClick="postToServer()">Send!</button>
        <button type="submit" id="sendButton" onClick="closeConnect()">End</button>
    </body>
</html>
