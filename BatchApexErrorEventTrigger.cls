trigger BatchApexErrorEventTrigger on BatchApexErrorEvent (after insert) {
    BatchApexErrorEventTriggerHelper.handleBatchErrorEvents(Trigger.New);
}