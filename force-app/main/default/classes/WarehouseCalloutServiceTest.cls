@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    private static void testEquipmentCallout() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        
        System.debug([SELECT count() FROM Product2]);
        System.assertEquals(1, [SELECT count() FROM Product2 WHERE Name = 'Fuse 8A']);
    } 

}