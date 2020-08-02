public with sharing class MaintenanceRequestHelper {
    private static final String NEW_TYPE = 'Routine Maintenance';
    private static final String NEW_STATUS = 'New'; 
    private static final String NEW_SUBJECT = 'New subject';

    public static void updateWorkOrders(List<Case> closedCases) {
       List<Case> newCases = new List<Case>(); 

       Map<Id, Integer> dayCounts = getLeastNumberOfDays(closedCases);
        
       for(Case closedCase: closedCases) {

           Case newCase = new Case(
                Type = NEW_TYPE,
                Status = NEW_STATUS,
                Date_Reported__c = Date.today(),
                Date_Due__c = Date.today().addDays(dayCounts.get(closedCase.Id)!= null?dayCounts.get(closedCase.Id): 0),
                Equipment__c = closedCase.Equipment__c,
                Vehicle__c = closedCase.Vehicle__c,
                Subject = closedCase.Subject != null? closedCase.Subject: NEW_SUBJECT
            );

            newCases.add(newCase);
       }

       if(newCases.size() > 0) {
           insert newCases;
       }
        
    }    
    
    private static Map<Id, Integer> getLeastNumberOfDays(List<Case> cases) {
        Map<Id, Integer> dayCounts = new Map<Id, Integer>();
        List<Work_Part__c> relatedParts = [SELECT Id, Equipment__r.Maintenance_Cycle__c, Maintenance_Request__r.Id FROM Work_Part__c WHERE Maintenance_Request__r.Id IN: cases];

        for(Work_Part__c wp: relatedParts) {
            for(Case c: cases) {
                if(wp.Maintenance_Request__r.Id == c.Id) {
                    if((dayCounts.containsKey(c.Id) && dayCounts.get(c.id) > wp.Equipment__r.Maintenance_Cycle__c) ||(!dayCounts.containsKey(c.Id))) {
                        dayCounts.put(c.Id, Integer.valueOf(wp.Equipment__r.Maintenance_Cycle__c));
                    }
                    
                    break;
                }
            }
            
        }
        
         return dayCounts;
    }
    
}