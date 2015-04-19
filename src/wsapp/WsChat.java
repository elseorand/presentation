package wsapp;

import java.io.IOException;
import java.util.concurrent.CopyOnWriteArrayList;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/wschat")
public class WsChat {
	private static final CopyOnWriteArrayList<Session> sessionList = new CopyOnWriteArrayList<>();

	@OnOpen
	public void onOpen(final Session session) {
		try {
			sessionList.addIfAbsent(session);
			session.getBasicRemote().sendText("Hello!");
		} catch (final IOException e) {
			e.printStackTrace();
		}
	}

	@OnClose
	public void onClose(final Session session) {
		sessionList.remove(session);
	}

	@OnMessage
	public void onMessage(final String msg) {
		try {
			for (final Session session : sessionList) {
				synchronized (session) {
					session.getBasicRemote().sendText(msg);
				}
			}
		} catch (final IOException e) {
			e.printStackTrace();
		}
	}
}
