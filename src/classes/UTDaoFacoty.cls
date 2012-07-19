@isTest
private class UTDaoFacoty {

	static testMethod void testGetDao() {
		Dao d = DaoFactory.getDao();
		System.assert(d instanceof SicDao);		
	} 

}