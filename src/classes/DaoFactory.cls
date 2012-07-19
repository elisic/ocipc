public class DaoFactory {
	public static Dao getDao() {
		return new SicDao();
	}

}