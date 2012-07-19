public class ceDebug {
    public String[] keys {get;set;}
    public String[] values {get; set;}

    public ceDebug(ApexPages.StandardSetController controller) {        
        this.keys = new List<String>();
        this.values= new List<String>();
        this.keys.addAll(ApexPages.currentPage().getParameters().keySet());
        this.values.addAll(ApexPages.currentPage().getParameters().values());
    }



}