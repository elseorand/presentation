package model.mahojong.Pai;

public enum PaiNumber {
	ONE(1), TWO(2), THREE(3), FOUR(4), FIVE(5), SIX(6), SEVEN(7), EIGHT(8), NINE(9), ;

	private final int	number;

	private PaiNumber(final int _number) {
		number = _number;
	}

	public int getNumber () {
		return number;
	}

}
