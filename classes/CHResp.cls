public class CHResp {
    public class resp{
        public String kind; //search#companies
        public Integer items_per_page;  //20
        public cls_items[] items;
        public Integer total_results;   //357
        public Integer page_number; //1
        public Integer start_index; //0
        }
    
    class cls_items {
        public String date_of_creation; //2017-02-02
        public String company_number;   //10598485
        public String kind; //searchresults#company
        // public cls_description_identifier[] description_identifier;
        // public cls_matches matches;
        public String description;  //10598485 - Incorporated on 2 February 2017
        public String company_type; //ltd
        public String snippet;  //
        public String title;    //COCA COLA COLLECTABLES INTERNATIONAL LIMITED
        public String address_snippet;  //204 Clements Road, Birmingham, West Midlands, United Kingdom, B25 8TS
        public cls_address address;
        public String company_status;   //active
        public cls_links links;
    }
    
/**    class cls_matches {
        public cls_title[] title;
        public cls_snippet[] snippet;
    }
    class cls_title {
    }
    class cls_snippet {
    } 
    
    class cls_description_identifier {
        public String 0;    //i
        public String 1;    //n
        public String 2;    //c
        public String 3;    //o
        public String 4;    //r
        public String 5;    //p
        public String 6;    //o
        public String 7;    //r
        public String 8;    //a
        public String 9;    //t
        public String 10;   //e
        public String 11;   //d
        public String 12;   //-
        public String 13;   //o
        public String 14;   //n
    } **/
   
 
    public class cls_address {
        public String country;  //United Kingdom
        public String postal_code;  //B25 8TS
        public String premises; //204 
        public String address_line_1;   //Clements Road
        public String region;   //West Midlands
        public String locality; //Birmingham
    }
    
    public class cls_links {
        public String self; ///company/10598485
    }
    public static resp parse(String json){
        return (resp) System.JSON.deserialize(json, resp.class);
    }

}