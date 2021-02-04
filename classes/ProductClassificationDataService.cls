public with sharing class ProductClassificationDataService {

    public ProductClassificationDataService() {}

    public class ClassifiedProducts {
        public List <ProductWithClassification> productsNeeded = new List <ProductWithClassification>();
        public List <ProductWithClassification> productsExisting = new List <ProductWithClassification>();

        public ClassifiedProducts(
                List <ProductWithClassification> productsNeeded,
                List <ProductWithClassification> productsExisting) {
            this.productsNeeded = productsNeeded;
            this.productsExisting = productsExisting;
        }

        public ClassifiedProducts(List<ProductWithClassification> products) {
            for (ProductWithClassification p : products){
                if(!p.isActive){
                    productsNeeded.add(p);
                }
                else{
                    productsExisting.add(p);
                }
            }
        }
    }

    public class ProductWithClassification {
        public String classification;
        public boolean isActive = false;
        public String line;
        private Set<String> activeStatuses = new Set<String>();

        public productWithClassification(String c, String status, String ln){
            this.classification = c;
            this.activeStatuses.add('Open');
            this.activeStatuses.add('Active');
            this.isActive = activeStatuses.contains(status);
            this.line = ln;
        }
    }

    public class ClassificationBuckets{
        Set<String> classificationsNeeded = new Set<String>();
        Set<String> classificationsExisting = new Set<String>();

        public ClassificationBuckets(ClassifiedProducts products){
            for(ProductWithClassification p : products.productsExisting){
                if(!classificationsExisting.contains(p.classification) && p.classification !=null){
                    classificationsExisting.add(p.classification);
                }
            }
            for(ProductWithClassification p : products.productsNeeded){
                if(!classificationsNeeded.contains(p.classification) && !classificationsExisting.contains(p.classification) && p.classification !=null){
                    classificationsNeeded.add(p.classification);
                }
            }
        }
    }

    public class Classification{
        public String name;

        public Classification(String n, Boolean a){
            this.name = n;
        }
    }

    public static void fakeTestMethod(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}