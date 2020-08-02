// This class can be safely deleted from your org. 
// It was only used to ensure 100% test coverage 
// for the managed package installation 

@IsTest
private class InstallationTests {

    private static final Integer CASES_COUNT = 300;

    @IsTest
    public static void testMaintenanceRequest(){
       List<Case> cases = TestDataFactory.initCaseData(CASES_COUNT);

       Test.startTest();

       for(Case c: cases) {
           c.Status = 'Closed';
           c.Type='Repair';
       }
        

       update cases;

       Test.stopTest();

       System.assertEquals(CASES_COUNT, [SELECT COUNT() FROM Case WHERE Status = 'New']);
    }
    
    @IsTest
    public static void testWarehouseSync(){
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}