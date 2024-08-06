public class BatchApexErrorEventTriggerHelper {

    public static void handleBatchErrorEvents(List<BatchApexErrorEvent> events) {
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        
        for (BatchApexErrorEvent event : events) {
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Name = 'Batch Error';
            errorLog.Async_Apex_Job_Id__c = event.AsyncApexJobId;
            errorLog.Message__c = event.Message;
            errorLogs.add(errorLog);
        }
        
        if (!errorLogs.isEmpty()) {
            insert errorLogs;
        }
    }

    
    /*public static void handleBatchErrorEventsForFurtherProcessing(List<BatchApexErrorEvent> events) {
        Set<Id> asyncApexJobIds = new Set<Id>();
        
        for (BatchApexErrorEvent evt : events) {
            asyncApexJobIds.add(evt.AsyncApexJobId);
        }
        
        Map<Id, AsyncApexJob> jobs = new Map<Id, AsyncApexJob>(
            [SELECT id, ApexClass.Name FROM AsyncApexJob WHERE Id IN :asyncApexJobIds]
        );

        List<Task> taskList = new List<Task>();
        for (BatchApexErrorEvent evt : events) {
            // Only handle events for a particular job
            if (jobs.get(evt.AsyncApexJobId).ApexClass.Name == 'PilotRatingBatch') {
                for (String item: event.JobScope.split(',')) {
                    // make some processing here
                    Task taskItem = new Task();
                    taskItem.WhatId = (Id) item;
                    taskItem.subject = evt.ExceptionType;
                    taskItem.Description = 'Error logged by Batch Apex class',
                    taskList.add(taskItem);
                }
            }
        }

        try {
            insert taskList;
        } catch(Exception ex) {
            System.debug('Exception while creating task ' + ex.getMessage());
        }
    }*/
}