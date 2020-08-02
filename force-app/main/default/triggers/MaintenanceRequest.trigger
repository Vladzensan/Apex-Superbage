trigger MaintenanceRequest on Case (before update, after update) {

    List<Case> cases = new List<Case>();

    for(Case c: Trigger.new) {
        if(c.IsClosed && (c.Type.equals('Repair') || c.Type.equals('Routine Maintenance'))) {
            cases.add(c);
        }
    }

    if(cases.size() > 0) {
        MaintenanceRequestHelper.updateWorkOrders(cases);
    }
}