public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future (callout = true)
    public static void runWarehouseEquipmentSync() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            List<Object> rawEquipmentList =  (List<Object>)JSON.deserializeUntyped(response.getBody());
            List<Product2> newEquipmentList = new List<Product2>();

            for(Object rawEquipment : rawEquipmentList) {

                Map<String, Object> item = (Map<String, Object>) rawEquipment;

                newEquipmentList.add(parseMapToProduct2(item));   

            }

            if(newEquipmentList.size() > 0) {
                upsert newEquipmentList Warehouse_SKU__c;
            }
        }
        
    }

    private static Product2 parseMapToProduct2(Map<String, Object> item) {
        return new Product2(
            ProductCode = (String)item.get('_id'),
            Replacement_Part__c = true,
            Name = (String)item.get('name'),
            Maintenance_Cycle__c = (Decimal)item.get('maintenanceperiod'),
            Lifespan_Months__c = (Decimal)item.get('lifespan'),
            Cost__c = (Decimal)item.get('cost'),
            Warehouse_SKU__c = (String)item.get('sku'),
            Current_Inventory__c = (Decimal)item.get('quantity')
        );
    }
}