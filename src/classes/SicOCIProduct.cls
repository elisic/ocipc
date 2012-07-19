public class SicOCIProduct implements OCIProduct {
    private SicProduct__c p;
    private Decimal qty; // calling it `quantity' causes naming conflict with get/setQuantity methods!
    public SicOCIProduct(SicProduct__c p) {
        this.p = p;
        this.qty = p.Price_Unit__c;
        this.qty.setScale(3, System.Roundingmode.HALF_UP);
    }
    private SicOCIProduct() {
        this.p = new SicProduct__c();
        this.qty = 0;
    }
     public ID getID() {
        return p.ID;
     }
     public String getCode() { //name
        return p.Name;
     }
     public String getCategory() {
        return p.Category__r.name;
     }
     public String getName() { //description
        return p.Description__c;
     }
     public String getDetail() {
        return p.Detail__c;
     }
     public Integer getLeadTime() {
        return p.Lead_Time__c.intValue();
     }
     public String getLeadTimeDisplay() {
        return p.Lead_Time_Display__c;
     }
     public String getDescription() { // long description
        return p.Long_Description__c;
     }
     public String getManufacturerProductNumber() {
        return p.Manufacturer_Product_Number__c;
     }
     public String getPictureDocumentID() {
        return p.PictureDocumentID__c;
     }
     public Decimal getOriginal_price() {
        return p.Price__c;
     }
     public String getOriginal_priceDisplay() {
        return p.Price_Display__c;
     }
     public Decimal getNegotiated_price() {
        if(p.Negotiated_Prices__r.size() > 0) {
            return p.Negotiated_Prices__r[0].Negotiated_Price__c;
        }
        else {
            return null;
        }
     }
     public String getNegotiated_priceDisplay() {
        if(p.Negotiated_Prices__r.size() > 0) {
            return p.Negotiated_Prices__r[0].Price_Display__c;
        }
        else {
            return '';
        }       
     }
     public Decimal getPrice() {
        if(p.Negotiated_Prices__r.size() > 0) {
            return p.Negotiated_Prices__r[0].Negotiated_Price__c;
        }
        else {
            return p.Price__c;
        }               
     }
     public String getPriceDisplay() {
        if(p.Negotiated_Prices__r.size() > 0) {
            return p.Negotiated_Prices__r[0].Price_Display__c;
        }
        else {
            return p.Price_Display__c;
        }                       
     }
     public Integer getPriceUnit() {
        return p.Price_Unit__c.intValue();
     }
     public String getCurrencyDisplay() {
        return p.Currency__c;
     }
     public String getUnitDisplay() {
        return p.Unit_Text__c;
     }
     public String getUnitISO() {
        return p.Unit_ISO__c;
     }
     public String getUNSPSCcode() {
        return p.UNSPSC_code__c;
     }
     public String getUNSPSC() {
        return p.UNSPSC__r.name;
     }
     // calculated
     public boolean getApproved() {
        return p.Negotiated_Prices__r.size()>0;
     }
     public String getQuantity() {
        return this.qty.toPlainString();
     }
     public void setQuantity(String value) {
         try {
            this.qty = decimal.valueOf(value);
         }
         catch (Exception e) {
             ApexPages.addMessages(e);
         }           
     }
     public Long getCost() {
        Decimal d_cost = this.qty * getPrice() / getPriceUnit();
        return d_cost.longValue();
     }
     public Long getSaving() {
        Decimal d_saving = this.qty * getOriginal_Price() / getPriceUnit() - getCost();
        return d_saving.longValue();
     }

	// TEST
	static testmethod void testCtor() {
		SicCategory__c c = new SicCategory__c(Name = 'cat1');
		insert c; 
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
		SicProduct__c sp = new SicProduct__c(
			Category__c = c.id,
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
		insert sp;

		Negotiated_Product__c np = new Negotiated_Product__c();
		np.Buyer__c = buyer.id;
		np.Product__c = sp.id;
		np.Negotiated_Price__c = 4;
		insert np;
		
		SicProduct__c sp2 = [select id, name from SicProduct__c where id = :sp.id];

		Dao dao = DaoFactory.getDao();		
		OCIProduct p = dao.fetchProductByID(sp.id, null); //no buyer
		
	    System.assertEquals(p.getID(), sp.Id);
	    System.assertEquals(p.getCode(), sp2.Name);
	    System.assertEquals(p.getCategory(), 'cat1');
	    System.assertEquals(p.getName(), 'desc1');
	    System.assertEquals(p.getDetail(), 'detail1');
	    System.assertEquals(p.getLeadTime(), 2);
	    System.assertEquals(p.getLeadTimeDisplay(), 'in 2 days');
	    System.assertEquals(p.getDescription(), 'longdesc1');
	    System.assertEquals(p.getManufacturerProductNumber(), 'mpn1');
	    System.assertEquals(p.getPictureDocumentID(), 'pdid');
	    System.assertEquals(p.getOriginal_price(), 5);
	    System.assertEquals(p.getOriginal_priceDisplay(), '5 CAD per 100 unittext1');
	    System.assertEquals(p.getNegotiated_price(), null);
	    System.assertEquals(p.getNegotiated_priceDisplay(), '');
	    System.assertEquals(p.getPrice(), 5);
	    System.assertEquals(p.getPriceDisplay(), '5 CAD per 100 unittext1');
	    System.assertEquals(p.getPriceUnit(), 100);
	    System.assertEquals(p.getCurrencyDisplay(), 'CAD');
	    System.assertEquals(p.getUnitDisplay(), 'unittext1');
	    System.assertEquals(p.getUnitISO(), 'iso');
	    System.assertEquals(p.getUNSPSCcode(), 'commoditycode1');
	    System.assertEquals(p.getUNSPSC(), 'unspsc1'); 
	    System.assertEquals(p.getApproved(), false);
	    
		p.setQuantity('700');	    
	    
	    System.assertEquals(p.getQuantity(), '700');
	    System.assertEquals(p.getCost(), 35);
	    System.assertEquals(p.getSaving(), 0);
	    
	    p = dao.fetchProductByID(sp.id, buyer.id); //buyer
	    
	    System.assertEquals(p.getOriginal_price(), 5);
	    System.assertEquals(p.getOriginal_priceDisplay(), '5 CAD per 100 unittext1');
	    System.assertEquals(p.getNegotiated_price(), 4);
	    System.assertEquals(p.getNegotiated_priceDisplay(), '4 CAD per 100 unittext1');
	    System.assertEquals(p.getPrice(), 4);
	    System.assertEquals(p.getPriceDisplay(), '4 CAD per 100 unittext1');
	    System.assertEquals(p.getPriceUnit(), 100);
	    System.assertEquals(p.getCurrencyDisplay(), 'CAD');
	    System.assertEquals(p.getApproved(), true);
	    
		p.setQuantity('700');	    
	    
	    System.assertEquals(p.getQuantity(), '700');
	    System.assertEquals(p.getCost(), 28);
	    System.assertEquals(p.getSaving(), 7);
	}
	
}