public with sharing class SicDao implements Dao{
    public Map<ID, OCIProduct> fetchAllToMap(ID buyerID) {
        Map<ID, OCIProduct> retval = new Map<ID, OCIProduct>();
        for(SicProduct__c p : [select
                                    id,
                                    name,
                                    Category__r.name,
                                    Description__c,
                                    Detail__c,
                                    Lead_Time__c,
                                    Lead_Time_Display__c,
                                    Long_Description__c,
                                    Manufacturer_Product_Number__c,
                                    PictureDocumentID__c,                           
                                    Price__c,
                                    Price_Display__c,                                   
                                    Price_Unit__c,
                                    Unit_Text__c,
                                    Currency__c,
                                    Unit_ISO__c,
                                    UNSPSC_code__c,
                                    UNSPSC__r.name,
                                     (Select id,
                                             Negotiated_Price__c,
                                             Price_Display__c 
                                      from Negotiated_Prices__r 
                                      where Buyer__c = :buyerID)
                                 from SicProduct__c]) {
            retval.put(p.ID, new SicOCIProduct(p));
        }
        return retval;
    }
    
    public OCIProduct fetchProductByID(ID productID, ID buyerID) {
        SicProduct__c p = [select
                                    id,
                                    name,
                                    Category__r.name,
                                    Description__c,
                                    Detail__c,
                                    Lead_Time__c,
                                    Lead_Time_Display__c,
                                    Long_Description__c,
                                    Manufacturer_Product_Number__c,
                                    PictureDocumentID__c,                           
                                    Price__c,
                                    Price_Display__c,                                   
                                    Price_Unit__c,
                                    Unit_Text__c,
                                    Currency__c,
                                    Unit_ISO__c,
                                    UNSPSC_code__c,
                                    UNSPSC__r.name,                                  
                                     (Select id,
                                             Negotiated_Price__c,
                                             Price_Display__c 
                                      from Negotiated_Prices__r 
                                      where Buyer__c = :buyerID)
                                 from SicProduct__c
                                 WHERE id = :productID
                                 ];
        return new SicOCIProduct(p);
    }
    
        //search function
    public Map<ID, OCIProduct> searchProductsByKeyword(String keyword, String categoryID, ID buyerID) {
        SicProduct__c[] products;
        if(keyword.trim().length() > 2) {        
            List<List<SObject>> searchresults;
            if(categoryID.trim().equals('all'))
                searchresults = [FIND :keyword RETURNING elisic__SicProduct__c (id)];
            else
                searchresults = [FIND :keyword RETURNING elisic__SicProduct__c (id WHERE Category__c = :categoryID)];
            products = [select
                                id,
                                name,
                                Category__r.name,
                                Description__c,
                                Detail__c,
                                Lead_Time__c,
                                Lead_Time_Display__c,
                                Long_Description__c,
                                Manufacturer_Product_Number__c,
                                PictureDocumentID__c,                           
                                Price__c,
                                Price_Display__c,                                   
                                Price_Unit__c,
                                Unit_Text__c,
                                Currency__c,
                                Unit_ISO__c,
                                UNSPSC_code__c,
                                UNSPSC__r.name,                                  
                                 (Select id,
                                         Negotiated_Price__c,
                                         Price_Display__c 
                                  from Negotiated_Prices__r 
                                  where Buyer__c = :buyerID)
                         from SicProduct__c
                         WHERE id IN : (elisic__SicProduct__c[])searchresults[0]];
        }
        else {
            if(categoryID.trim().equals('all'))
                products = [select
                                    id,
                                    name,
                                    Category__r.name,
                                    Description__c,
                                    Detail__c,
                                    Lead_Time__c,
                                    Lead_Time_Display__c,
                                    Long_Description__c,
                                    Manufacturer_Product_Number__c,
                                    PictureDocumentID__c,                           
                                    Price__c,
                                    Price_Display__c,                                   
                                    Price_Unit__c,
                                    Unit_Text__c,
                                    Currency__c,
                                    Unit_ISO__c,
                                    UNSPSC_code__c,
                                    UNSPSC__r.name,                                  
                                     (Select id,
                                             Negotiated_Price__c,
                                             Price_Display__c 
                                      from Negotiated_Prices__r 
                                      where Buyer__c = :buyerID)
                             from SicProduct__c];
            else
                products = [select
                                    id,
                                    name,
                                    Category__r.name,
                                    Description__c,
                                    Detail__c,
                                    Lead_Time__c,
                                    Lead_Time_Display__c,
                                    Long_Description__c,
                                    Manufacturer_Product_Number__c,
                                    PictureDocumentID__c,                           
                                    Price__c,
                                    Price_Display__c,                                   
                                    Price_Unit__c,
                                    Unit_Text__c,
                                    Currency__c,
                                    Unit_ISO__c,
                                    UNSPSC_code__c,
                                    UNSPSC__r.name,                                  
                                     (Select id,
                                             Negotiated_Price__c,
                                             Price_Display__c 
                                      from Negotiated_Prices__r 
                                      where Buyer__c = :buyerID)
                             from SicProduct__c
                             WHERE Category__c = :categoryID];
        }
        Map<ID, OCIProduct> retval = new Map<ID, OCIProduct>();
        for(SicProduct__c p : products) {
            retval.put(p.ID, new SicOCIProduct(p));
        }
        return retval;             
    }
 
}