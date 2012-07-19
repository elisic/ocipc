public class ceUploadPictureDocument {

    public Document PictureDocument {get; set;}
    private SicProduct__c product;
    public ceUploadPictureDocument(ApexPages.StandardController controller) {
        this.product = (SicProduct__c)controller.getRecord();
        PictureDocument = new Document();
    }

    public PageReference doUploadPicture() {
        Folder folder = [select id from Folder where DeveloperName = 'SicProduct_Pictures'];
        PictureDocument.FolderID = folder.id;
        PictureDocument.IsPublic = true;
        insert Picturedocument;
        product.PictureDocumentID__c = PictureDocument.ID;
        update product;
        PageReference thePage = new PageReference( '/'+ product.id);
        thePage.setRedirect( true );        
        return thePage;        
    }
    

}