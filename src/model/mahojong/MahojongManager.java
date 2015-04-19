package model.mahojong;

import java.util.ArrayList;
import java.util.List;

import model.GameManager;
import model.client.Client;

public class MahojongManager implements GameManager {

	private final List<Client>	client_s	= new ArrayList<>(4);

	private MahojongManager(final List<Client> _client_s) {
		if (_client_s.size() > this.getLimitMemberNum()) {
			throw new IllegalArgumentException("This game is for " + this.getLimitMemberNum() + " members.");
		}
		client_s.clear();// 無意味であるが一応
		client_s.addAll(_client_s);
	}

	public int getLimitMemberNum () {
		return 4;
	}
	/*
	 * public MessageWithResults addMember ( final List<Client> _new_mem_s ) {
	 * final int NEW_NUM = client_s.size() + _new_mem_s.size(); if (NEW_NUM >
	 * this.getLimitMemberNum()) { final MessageJson message =
	 * MessageJson.newInstance("This game is for " + this.getLimitMemberNum() +
	 * " members."); return MessageWithResults.newInstance(ResultsEnum.FAILURE,
	 * message); } else if (NEW_NUM < this.getLimitMemberNum()) { final
	 * MessageJson message = MessageJson.newInstance("This game is for " +
	 * this.getLimitMemberNum() + " members."); return
	 * MessageWithResults.newInstance(ResultsEnum.SUCCESS, message); } else {
	 * final MessageJson message = MessageJson.newInstance("Ready"); return
	 * MessageWithResults.newInstance(ResultsEnum.COMPLETE, message); }
	 * 
	 * }
	 */
}
