package model.mahojong.Pai;

public enum PaiID {
	Frst(1), Scnd(2), Thre(3), Four(4), ;

	private int	id;

	private PaiID(final int _id) {
		id = _id;
	}

	public int getId () {
		return id;
	}

}
