@isTest
public class WarehouseSyncScheduleTest {
    @isTest
    public static void testScheduleJob() {
        
        WarehouseSyncSchedule warehouse = new WarehouseSyncSchedule();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobId = System.schedule('Update warehouse', '0 0 0 * * ? *', warehouse);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM AsyncApexJob]);
    }
}