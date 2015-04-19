package model.mahojong.Pai;

public class Pai {

	public final PaiType		type;
	public final PaiNumber		number;
	public final PaiID			id;
	public final PaiAttribute	attr;

	private Pai(final PaiType _type, final PaiNumber _number, final PaiID _id) {
		type = _type;
		number = _number;
		id = _id;
		attr = PaiAttribute.NORMAL;
	}

	public Pai newInstance ( final PaiType _type, final PaiNumber _number, final PaiID _id ) {
		if (_type == null || _number == null || _id == null) {
			throw new IllegalArgumentException("not null");
		}
		return new Pai(_type, _number, _id);
	}

	/*
	 * (非 Javadoc)
	 * 
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString () {
		return "{\"Pai\":{\"type\":" + type + ", number\":" + number + ", id\":" + id + ", attr\":" + attr + "}";
	}

	/*
	 * (非 Javadoc)
	 * 
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode () {
		final int prime = 31;
		int result = 1;
		result = prime * result + (attr == null ? 0 : attr.hashCode());
		result = prime * result + (id == null ? 0 : id.hashCode());
		result = prime * result + (number == null ? 0 : number.hashCode());
		result = prime * result + (type == null ? 0 : type.hashCode());
		return result;
	}

	/*
	 * (非 Javadoc)
	 * 
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals ( final Object obj ) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (!(obj instanceof Pai)) {
			return false;
		}
		final Pai other = (Pai) obj;
		if (attr != other.attr) {
			return false;
		}
		if (id != other.id) {
			return false;
		}
		if (number != other.number) {
			return false;
		}
		if (type != other.type) {
			return false;
		}
		return true;
	}

}
