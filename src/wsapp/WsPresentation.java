package wsapp;

import java.io.IOException;
import java.util.concurrent.CopyOnWriteArrayList;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/ws_presentation")
public class WsPresentation {

	private static final CopyOnWriteArrayList<Session>	sessionList	= new CopyOnWriteArrayList<>();
	private static String								content		= "{\"init_content\":\"\"}";
	private static String								page		= "{\"page\":0}";

	private static void init () {
		content = "{\"init_content\":\"\"}";
		page = "{\"page\":0}";
	}

	@OnOpen
	public void onOpen ( final Session session ) {
		try {
			sessionList.addIfAbsent(session);
			session.getBasicRemote().sendText(content);
			session.getBasicRemote().sendText(page);
		} catch (final IOException e) {
			e.printStackTrace();
		}
	}

	@OnClose
	public void onClose ( final Session session ) {
		sessionList.remove(session);
	}

	@OnMessage
	public void onMessage ( final String raw_msg ) {
		final String msg = raw_msg;
		synchronized (msg) {
			if (msg.indexOf("init_content") != -1) {
				content = msg;
			} else if (msg.indexOf("page") != -1) {
				page = msg;
			} else if (msg.indexOf("close_presentation") != -1) {
				init();
			}
		}

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
