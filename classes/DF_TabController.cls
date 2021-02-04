public class DF_TabController {
    
    public Integer randomSuffix{get;set;}
    
    public DF_TabController(){
        randomSuffix = getRandomNumber(1000000);
    }
    
    private Integer getRandomNumber(Integer size){
        Double d = Math.random() * size;
        return d.intValue();
    }
    
}