package model.mahojong.Pai;

public enum PaiType {
	SOZU("索子"), PINZU("筒子"), MANZU("萬子");

	private final String	type;

	private PaiType(final String _type) {
		type = _type;

	}

	public String getType () {
		return type;
	}

}
