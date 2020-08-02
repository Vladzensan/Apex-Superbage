public class TestDataFactory {

    public static List<Case> initCaseData(Integer count) {
         List<Case> cases = new List<Case>();

        for(Integer i = 0; i < count; i++) {
            Case c = new Case(Subject ='Subject');
            cases.add(c);
        }
        
        insert cases;
        
        List<Work_Part__c> workParts = new List<Work_Part__c>();
        for(Case c: cases) {
            Work_Part__c wp = new Work_Part__c(Maintenance_Request__c=c.Id);
           	workParts.add(wp);
        }
        insert workParts;

        return cases;
    }

}