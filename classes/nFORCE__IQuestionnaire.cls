/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IQuestionnaire {
    List<nFORCE__Answer__c> getAnswerData(Id param0, Id param1);
    List<nFORCE__Question__c> getQuestionData();
    void setAnswers(Id param0, Id param1);
    void setAnswers(Map<Id,nFORCE.Answer> param0);
    void setConditionalQuestions();
    void setGroupId(Id param0);
    void setQuestions();
    void setQuestions(List<nFORCE.Question> param0);
}
