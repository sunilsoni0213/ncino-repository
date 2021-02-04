global class getCreditMemosToDelete implements Schedulable {
    global void execute(SchedulableContext ctx) {   
        CreditMemoDeleterController.deleteCreditMemos();
    }
}