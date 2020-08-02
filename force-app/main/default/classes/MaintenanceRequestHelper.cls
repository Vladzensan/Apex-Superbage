public with sharing class MaintenanceRequestHelper {
    private static final Integer CYCLE_UPPERBOUND = 19;
    
    public static void updateWorkOrders(List<Case> closedCases) {
       List<Case> newCases = new List<Case>();

       

       for(Case closedCase: closedCases) {
           Integer minDays = getLeastNumberOfDays(closedCase);

           closedCase = [SELECT Type, Status, Equipment__c, Vehicle__c, Subject FROM Case WHERE Id=:closedCase.Id];
           Case newCase = new Case(
                Type = 'Routine Maintenance',
                Status = 'New',
                Date_Reported__c = Date.today(),
                Date_Due__c = Date.today().addDays(minDays),
                Equipment__c = closedCase.Equipment__c,
                Vehicle__c = closedCase.Vehicle__c,
                Subject = closedCase.Subject != null? closedCase.Subject: 'New case'
            );

            newCases.add(newCase);
       }

       if(newCases.size() > 0) {
           insert newCases;
       }
        
    }    
    
    
    private static Integer getLeastNumberOfDays(Case c) {

        List<Work_Part__c> relatedParts = [SELECT Id, Equipment__r.Maintenance_Cycle__c FROM Work_Part__c WHERE Maintenance_Request__r.Id=:c.Id];

        Integer min = 0;
        if(relatedParts.size() > 0) {
            min = Integer.valueOf(relatedParts.get(0).Equipment__r.Maintenance_Cycle__c); 
        }

        for(Work_Part__c part: relatedParts) {
            if(part.Equipment__r.Maintenance_Cycle__c < min) {
                min = Integer.valueOf(part.Equipment__r.Maintenance_Cycle__c);
            }
        }

        return min;
    }
    
}