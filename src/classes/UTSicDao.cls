@isTest
private class UTSicDao {

    static testmethod void testFetchAll() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	Map<ID, OCIProduct> products = dao.fetchAllToMap(null);
    	// System.assertEquals(3, products.size());
    	System.assertEquals(products.get(ids[0]).getID() , ids[0]);
    	System.assertEquals(products.get(ids[1]).getID() , ids[1]);
    	System.assertEquals(products.get(ids[2]).getID() , ids[2]);
    	System.assertEquals(products.get(ids[3]).getID() , ids[3]);
    }
    static testmethod void testFetchbyID() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	OCIProduct p = dao.fetchProductByID(ids[0], null);
    	System.assertEquals(p.getName(), 'desc1');
    }
    
    public static ID[] setupSearchTestData() {
		SicCategory__c c1 = new SicCategory__c(Name = 'cat1');
		insert c1; 
		SicCategory__c c2 = new SicCategory__c(Name = 'cat2');
		insert c2; 
		UNSPSC__c unspsc = new UNSPSC__c();
		unspsc.Name = 'unspsc1';
		unspsc.Commodity_Code__c = 'commoditycode1';
		insert unspsc;
		Unit__c unit = new Unit__c();
		unit.ISO__c = 'iso';
		unit.Name = 'unit1';
		unit.Text__c = 'unittext1';
		insert unit;
		Buyer__c buyer = new Buyer__c();
		buyer.name = 'city';
		buyer.User_Name__c = 'username';
		buyer.Password__c = 'password';
		insert buyer;

		// product w/ category w/ buyer
		SicProduct__c sp_cat_buyer = new SicProduct__c(
			Category__c = c1.id,
			Currency__c = 'CAD',
			Description__c = 'desc1',
			Detail__c = 'detail1',
			Lead_Time__c = 2,
			Long_Description__c = 'longdesc1',
			Manufacturer_Product_Number__c = 'mpn1',
			PictureDocumentID__c = 'pdid',
			Price_Unit__c = 100,
			Price__c = 5,
			UNSPSC__c = unspsc.id,
			Unit__c = unit.id
		);
		insert sp_cat_buyer;
		Negotiated_Product__c np1 = new Negotiated_Product__c();
		np1.Buyer__c = buyer.id;
		np1.Product__c = sp_cat_buyer.Id;
		np1.Negotiated_Price__c = 4;
		insert np1;

		// product w/ category no buyer
		SicProduct__c sp_cat_nobuyer = new SicProduct__c(
			Category__c = c1.id,
			Currency__c = 'CAD',
			Description__c = 'desc2',
			Detail__c = 'detail2',
			Lead_Time__c = 2,
			Long_Description__c = 'longdesc2',
			Manufacturer_Product_Number__c = 'mpn2',
			PictureDocumentID__c = 'pdid',
			Price_Unit__c = 100,
			Price__c = 5,
			UNSPSC__c = unspsc.id,
			Unit__c = unit.id
		);
		insert sp_cat_nobuyer;
		
		// product no category w/ buyer
		SicProduct__c sp_nocat_buyer = new SicProduct__c(
			Category__c = c2.id,
			Currency__c = 'CAD',
			Description__c = 'desc3',
			Detail__c = 'detail3',
			Lead_Time__c = 2,
			Long_Description__c = 'longdesc3',
			Manufacturer_Product_Number__c = 'mpn3',
			PictureDocumentID__c = 'pdid',
			Price_Unit__c = 100,
			Price__c = 5,
			UNSPSC__c = unspsc.id,
			Unit__c = unit.id
		);
		insert sp_nocat_buyer;
		Negotiated_Product__c np2 = new Negotiated_Product__c();
		np2.Buyer__c = buyer.id;
		np2.Product__c = sp_nocat_buyer.id;
		np2.Negotiated_Price__c = 4;
		insert np2;
		
		// product no category no buyer
		SicProduct__c sp_nocat_nobuyer = new SicProduct__c(
			Category__c = c2.id,
			Currency__c = 'CAD',
			Description__c = 'desc4',
			Detail__c = 'detail4',
			Lead_Time__c = 2,
			Long_Description__c = 'longdesc4',
			Manufacturer_Product_Number__c = 'mpn4',
			PictureDocumentID__c = 'pdid',
			Price_Unit__c = 100,
			Price__c = 5,
			UNSPSC__c = unspsc.id,
			Unit__c = unit.id
		);
		insert sp_nocat_nobuyer;
		
		//return IDs in order
		ID[] retval = new ID[4];
		retval[0] = sp_cat_buyer.id;
		retval[1] = sp_cat_nobuyer.id;
		retval[2] = sp_nocat_buyer.id;
		retval[3] = sp_nocat_nobuyer.id;
		
		// set up search results
		Test.setFixedSearchResults(retval);
		
		return retval;
   }
    
    static testmethod void testSearchNoKeywordAllNoBuyer() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	Map<ID, OCIProduct> products = dao.searchProductsByKeyword('', 'all', null);
    	System.assert(products.containsKey(ids[0]));
    	System.assert(products.containsKey(ids[1]));
    	System.assert(products.containsKey(ids[2]));
    	System.assert(products.containsKey(ids[3]));    	
    }
    static testmethod void testSearchNoKeywordAllBuyer() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	Buyer__c buyer = [select id from Buyer__c where name = 'city'];
    	Map<ID, OCIProduct> products = dao.searchProductsByKeyword('', 'all', buyer.id);
    	System.assert(products.containsKey(ids[0]));
    	System.assert(products.containsKey(ids[2]));
    }
    static testmethod void testSearchNoKeywordCategoryNoBuyer() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	SicCategory__c category = [select id from SicCategory__c where name = 'cat1'];
    	Map<ID, OCIProduct> products = dao.searchProductsByKeyword('', category.id, null);
    	System.assert(products.containsKey(ids[0]));
    	System.assert(products.containsKey(ids[1]));
    }
    static testmethod void testSearchNoKeywordCategoryBuyer() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	Buyer__c buyer = [select id from Buyer__c where name = 'city'];
    	SicCategory__c category = [select id from SicCategory__c where name = 'cat1'];
    	Map<ID, OCIProduct> products = dao.searchProductsByKeyword('', category.id, buyer.id);
    	System.assert(products.containsKey(ids[0]));
    }
    static testmethod void testSearchKeywordAllNoBuyer() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	Map<ID, OCIProduct> products = dao.searchProductsByKeyword('dummy', 'all', null);
    	System.assertEquals(products.size(), 4);
    }
    static testmethod void testSearchKeywordAllBuyer() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	Buyer__c buyer = [select id from Buyer__c where name = 'city'];
    	Map<ID, OCIProduct> products = dao.searchProductsByKeyword('dummy', 'all', buyer.id);
    	System.assertEquals(products.size(), 4);
    }
    static testmethod void testSearchKeywordCategoryNoBuyer() {
    	ID[] ids = setupSearchTestData();
    	SicDao dao = new SicDao();
    	SicCategory__c category = [select id from SicCategory__c where name = 'cat1'];
    	Map<ID, OCIProduct> products = dao.searchProductsByKeyword('dummy', category.id, null);
    	System.assertEquals(products.size(), 2);
    	System.assert(products.containsKey(ids[0]));
    	System.assert(products.containsKey(ids[1]));
    	
    }
    static testmethod void testSearchKeywordCategoryBuyer() {
    	ID[] ids =  setupSearchTestData();
    	SicDao dao = new SicDao();
    	SicCategory__c category = [select id from SicCategory__c where name = 'cat1'];
    	Buyer__c buyer = [select id from Buyer__c where name = 'city'];
    	Map<ID, OCIProduct> products = dao.searchProductsByKeyword('dummy', category.id, buyer.id);
    	System.assertEquals(products.size(), 2);
    	System.assert(products.containsKey(ids[0]));
    	System.assert(products.containsKey(ids[1]));
    }
}