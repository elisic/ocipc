@isTest
private class UTUploadPictureController {

    static testMethod void myUnitTest() {
		SicProduct__c p = new SicProduct__c();
		insert p;
        
        ApexPages.StandardController sc;
        ceUploadPictureDocument ceUploadTest;
        
        Document doc = new Document();
        
        Test.startTest();
        sc = new ApexPages.StandardController(p);
        ceUploadTest = new ceUploadPictureDocument(sc);
        ceUploadTest.PictureDocument = doc;
        ceUploadTest.PictureDocument.Name = 'testdoc';
        ceUploadTest.PictureDocument.Body = Blob.valueOf('test');
        ceUploadTest.PictureDocument.ContentType = 'image/jpeg';
        ceUploadTest.doUploadPicture();
        System.assert(ceUploadTest.PictureDocument.Name == 'testdoc');
        Test.stopTest();
    }
}