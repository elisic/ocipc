public with sharing class OCIController {

    public String FUNCTION {get; set; }
    public String HOOK_URL {get; set; }
    public String OCI_VERSION {get; set; }
    public String OPI_VERSION {get; set; }
    public String http_content_charset {get; set;}
    public String returntarget {get; set;}
    public String PRODUCTID {get; set; }
    public String QTY {get; set; }
    public String SEARCHSTRING {get; set; }
    private String username;
    private String password;
    private ID buyerID;
    private Dao dao;
    private Map<ID, OCIProduct> FoundAllProducts;
    private Map<ID, OCIProduct> FoundApprovedProducts;
    private Map<ID, OCIProduct> SelectedProducts;
    private Map<ID, SicCategory__c> categories;

    public OCIController() {
        System.debug(ApexPages.currentPage().getParameters());
        this.FUNCTION = ApexPages.currentPage().getParameters().get('FUNCTION');
        this.HOOK_URL = ApexPages.currentPage().getParameters().get('HOOK_URL');
        this.OCI_VERSION = ApexPages.currentPage().getParameters().get('OCI_VERSION');
        this.OPI_VERSION = ApexPages.currentPage().getParameters().get('OPI_VERSION');
        this.http_content_charset = ApexPages.currentPage().getParameters().get('http_content_charset');
        this.returntarget = ApexPages.currentPage().getParameters().get('returntarget');
        this.PRODUCTID = ApexPages.currentPage().getParameters().get('PRODUCTID');
        this.QTY = ApexPages.currentPage().getParameters().get('QUANTITY');
        this.SEARCHSTRING = ApexPages.currentPage().getParameters().get('SEARCHSTRING');
        this.currentCategoryID = 'all'; //needs to be inititalized
        username = ApexPages.currentPage().getParameters().get('username');
        password = ApexPages.currentPage().getParameters().get('password');
        try {
            Buyer__c buyer = [select id from Buyer__c where User_Name__c = :username and Password__c =: password];
            buyerID = buyer.id;
        }
        catch (System.QueryException qe) {
            buyerID = null;
        }
         
        this.dao = DaoFactory.getDao();
        // initialize private variables here!
        this.categories = new Map<ID, SicCategory__c>([select id, name from SicCategory__c]);
        this.FoundAllProducts = dao.fetchAllToMap(buyerID);
        this.FoundApprovedProducts = findApprovedProducts(FoundAllProducts);
        System.debug(this.FoundAllProducts);
        this.SelectedProducts = new Map<ID, OCIProduct>();
        this.filterApprovedOnly = false;
        this.currentProductID = null;
    }

    // navigation methods
    //*******************
    public PageReference displayCheckout() {
        PageReference pref = Page.OCI_Checkout;
        return pref;
    }

    public PageReference displayCatalog() {
                PageReference pref = Page.OCI_Catalog;
                return pref;
    }
    
    public PageReference displayDetail() {
        PageReference pref = Page.OCI_Detail;
        this.PRODUCTID = currentProductId;
        return pref;
    }
    // properties
    //***********
    // search for this text
    public String searchFor {
        get {
            return searchFor;
        }
        set {
            searchFor = value.trim();
        }
    }
    
    // list of Products found    
    public List<OCIProduct> getFoundProducts(){
        if(this.filterApprovedOnly) {
            return this.FoundApprovedProducts.values();
        }   
        else
            return this.FoundAllProducts.values();
    }
    public String getNumberOfProductsFound() {
        if(this.filterApprovedOnly)
            return this.FoundApprovedProducts.size().format();
        else
            return this.FoundAllProducts.size().format();
    }
    // list of Products selected into the shopping basket
    public List<OCIProduct> getSelectedProducts() {
        return this.SelectedProducts.values();
    }
    public void setSelectedProducts(List<OCIProduct> selection) {
        for(OCIProduct op : selection)
                this.SelectedProducts.put(op.getID(), op);
    }

    public String currentCategoryID {get; set;}
    public List<SicCategory__c> getCategories() {
        return categories.values();
    }
    public String getCurrentcategoryName() {
        if(currentCategoryID.trim().equals('all'))
            return 'All';
        else
            return categories.get(currentCategoryID).name;
    }
    public Attachment[] getAttachments() {
        return [select id, name, description from Attachment where parentID = :PRODUCTID];
    }
    
    public OCIProduct getDetailProduct() {
        return dao.fetchProductbyID(PRODUCTID, buyerID);
    }
    
    public boolean getIsBuyer() {
        return ( buyerID != null);
    }
    public boolean filterApprovedOnly {get; set;}
    
    // Action methods
    // **************
    // current product ID
    // action methods are invoked from command links 
    // that first set this property to provide context
    public ID currentProductID {
        get; 
        set {
            currentProductID = value;
            System.debug(currentProductID);
        }
    }

    public PageReference addCurrentProductToSelected() {
        OCIProduct product = FoundAllProducts.get(currentProductID);
        if (product == null)
                product = dao.fetchProductByID(currentProductID, buyerID);
                //[select id, name, Description__c, Long_Description__c, Lead_Time__c, Lead_Time_Display__c, Price__c, Price_Unit__c, Price_Display__c, Unit_Text__c, Unit_ISO__c, Currency__c, Manufacturer_Product_Number__c, UNSPSC_code__c from SicProduct__c WHERE id = :currentProductID];
        if (SelectedProducts == null) SelectedProducts = new Map<ID, OCIProduct>();
        SelectedProducts.put(currentProductID, product);
        return null;
    }
    public PageReference addToCartAndDisplayCatalog() {
        addCurrentPRoductToSelected();
        return displayCatalog();
    }
    public PageReference removeCurrentProductFromSelected() {
        this.SelectedProducts.remove(currentProductID);
        return null;
    }
        
    // search action
    public PageReference SearchProducts() {
        if(searchFor == null) searchFor = '';
        FoundAllProducts = dao.searchProductsByKeyword(SearchFor, currentCategoryID, buyerID);
        this.FoundApprovedProducts = findApprovedProducts(FoundAllProducts);
        return null;
    }
    
    // init: capture parameters from OCI call and route request
    public PageReference init() {
        if (FUNCTION == 'DETAIL') {
            Pagereference pref = Page.OCI_Detail;
            pref.getParameters().put('username', username);
            pref.getParameters().put('password', password);
            pref.getParameters().put('PRODUCTID', PRODUCTID);
            pref.setRedirect(true);
            return pref;
        }
        else if (FUNCTION == 'VALIDATE') {
            OCIProduct product = dao.fetchProductbyID(PRODUCTID, buyerID);
            product.setQuantity(QTY.trim());
            SelectedProducts = new Map<ID, OCIProduct>();
            SelectedProducts.put(product.getID(), product);
            return null;
        }
        else if (FUNCTION == 'BACKGROUND_SEARCH') {
            SelectedProducts = dao.searchProductsByKeyword('*' + SEARCHSTRING + '*', 'all', buyerID);
            return null; // background search has to use the same URL
        }
        else { //default: show Product Catalog
            PageReference pref = Page.OCI_Catalog;
            pref.getParameters().put('username', username);
            pref.getParameters().put('password', password);
            pref.getParameters().put('HOOK_URL', HOOK_URL);
            pref.getParameters().put('returntarget', returntarget);
            pref.setRedirect(true);
            return pref;
        }
    }
    
    private Map<ID, OCIProduct> findApprovedProducts(Map<ID, OCIProduct> all) {
        System.debug(all);
        Map<ID, OCIProduct> approved = all.clone();
        for(OCIProduct p : all.values()) {
            if(!p.getApproved()) {
                approved.remove(p.getID());
            }
        }
        return approved;
    }
    
}