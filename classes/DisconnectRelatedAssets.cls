public class DisconnectRelatedAssets
{

    @InvocableMethod 
    public static void sendRelatedAssetsforUpdate(List<List<Asset>> assetIds) {
       System.debug('List<List<Asset>> ' + assetIds);
        Map<Id, Asset> assetMap = new Map<Id, Asset>();
        List<Asset> assetList = assetIds.get(0);
        System.debug('List<Asset> ' + assetIds);
        for (Asset a : assetList) {
              a.status = 'Disconnected';
              assetMap.put(a.id, a);
        }
        System.debug(' Map<Id, Asset> assetMap ' + assetMap);
      
        Database.SaveResult[] saveResults = Database.update(assetMap.values(), false);
    
        List< Asset_Disconnection__e > disconnectionEvents = new List< Asset_Disconnection__e >() ;
    
        for (Database.SaveResult sr : saveResults) {
            if (sr.isSuccess()) {
                disconnectionEvents.add(new Asset_Disconnection__e(Asset_Identifier__c = assetMap.get(sr.getId()).Asset_Identifier__c, Disconnected__c = true));

            }else {              
                for(Database.Error err : sr.getErrors()) {
                    disconnectionEvents.add(new Asset_Disconnection__e(Asset_Identifier__c = assetMap.get(sr.getId()).Asset_Identifier__c, Disconnected__c = false));
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
    
            List<Database.SaveResult> eventsResults = EventBus.publish(disconnectionEvents);
            disconnectionEvents.clear();
            for (Database.SaveResult sre : eventsResults) {
                if (sre.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err : sre.getErrors()) {
                        System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage());
                    }
                }       
            }
        } 
    }
}