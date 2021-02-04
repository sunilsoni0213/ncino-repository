global class DynamicInitialize {
    @RemoteAction
    global static Set<Id> getSourceFile() {
        Set<Id> fileIds = new Set<Id>();
        fileIds.addAll(new Map<Id,ApexPage>([SELECT Id From ApexPage WHERE Name != 'InitiDemo']).keySet());
        fileIds.addAll(new Map<Id,ApexComponent>([SELECT Id From ApexComponent]).keySet());
        return fileIds;
    }

    @RemoteAction
    global static List<Resource> getResources() {
        List<Resource> resources = new List<Resource>();
        for (sObject source : [SELECT NamespacePrefix,Markup From ApexComponent]) {
            resources.addAll(getReferences(source));
        }
        for (sObject source : [SELECT NamespacePrefix,Markup From ApexPage]) {
            resources.addAll(getReferences(source));
        }
        for (StaticResource source : [SELECT NamespacePrefix,Name,contentType From StaticResource]) {
            if (source.contentType.contains('css') || source.contentType.contains('application') || source.contentType.contains('javascript')) {
                Resource r = new Resource();
                r.url = replaceResourceReference('$Resource.' + source.Name, source.NamespacePrefix);
                r.type = (source.contentType.contains('css') ? 'CSS' : 'Script');
                r.hashcode = 'HASH'+String.valueOf(Math.abs(System.hashcode(r.url)));
                resources.add(r);
            }
        }
        return resources;
    }

    @RemoteAction
    global static List<Resource> processFile(Id fileId) {
        List<Resource> resources = getReferences(fileId);
        return resources;
    }

    global static List<Resource> getReferences(Id fileId) {
        sObject source = Database.query('SELECT NamespacePrefix,Markup From ' + fileId.getSobjectType().getDescribe().getName() + ' WHERE Id =: fileId');
        return  getReferences(source);
    }

     global static List<Resource> getReferences(sObject source) {
         List<Resource> resources = new List<Resource>();
         try {
            resources.addAll(
                getScript(
                    (String)source.get('Markup'),
                    ((String)source.get('NamespacePrefix')).toLowercase()
                )
            );
            resources.addAll(
                getCSS(
                    (String)source.get('Markup'),
                    ((String)source.get('NamespacePrefix')).toLowercase()
                )
            );
         }
         catch (Exception x) {
            System.debug('Skipped Invalid File:' + source.Id);
            System.debug(x);
         }
        return resources;
    }

    global static List<Resource> getScript(String content, String namespace) {
        List<Resource> resources = new List<Resource>();
        for (String token : getValueTokens(content, 'apex:includeScript')) {
            String url = getURL(token, namespace);
            if (url != null) {
                Resource resource = new Resource();
                resource.url = url;
                resource.type = 'Script';
                resource.hashcode = 'HASH'+String.valueOf(Math.abs(System.hashcode(resource.url)));
                resources.add(resource);
            }
        }
        return resources;
    }

    global static List<Resource> getCSS(String content, String namespace) {
        List<Resource> resources = new List<Resource>();
        for (String token : getValueTokens(content, 'apex:stylesheet')) {
            String url = getURL(token, namespace);
            if (url != null) {
                Resource resource = new Resource();
                resource.url = url;
                resource.type = 'CSS';
                resource.hashcode = 'HASH'+String.valueOf(Math.abs(System.hashcode(resource.url)));
                resources.add(resource);
            }
        }
        return resources;
    }

    global static List<String> getValueTokens(String content, String enclosure) {
        List<String> tokens = new List<String>();

        Integer startIndex = content.indexOfIgnoreCase(enclosure);
        while (startIndex >= 0) {
            Integer endIndex = content.indexOfIgnoreCase('/>',startIndex+1);
            startIndex = content.indexOfIgnoreCase('value=',startIndex);
            startIndex = content.indexOfIgnoreCase('"',startIndex) + 1;
            endIndex = content.indexOfIgnoreCase('"',startIndex);
            tokens.add(content.subString(startIndex,endIndex).trim());
            startIndex = content.indexOfIgnoreCase(enclosure, endIndex);
        }

        return tokens;
    }

    global static String getURL(String value, String namespace) {
        if (value.contains('[') || value.contains('+')) {
            return null;
        }

        value = value.replace('{!','');
        value = value.replace('}','');

        if (value.containsIgnoreCase('URLFOR')) {
            Integer startindex = value.indexOf('URLFOR');
            Integer endIndex = value.indexOf(')', startindex);
            List<String> parts = getURLForValues(value);
            if (parts.size() == 1) {
                value =
                    value.subString(0,startIndex) +
                    replaceResourceReference(parts[0],namespace) +
                    value.substring(endIndex+1);
            }
            else {

                value =
                    value.subString(0,startIndex) +
                    replaceResourceReference(parts[0],namespace) + '/' + parts[1] +
                    value.substring(endIndex+1);
            }
            value = value.replace('//','/');
        }

        return replaceResourceReference(value, namespace);
    }

    global static List<String> getURLForValues(String value) {
        System.debug(value);
        Integer startindex = value.indexOfIgnoreCase('(');
        Integer endindex = value.indexOfIgnoreCase(')');
        value = value.substring(startindex+1, endindex);
        List<String> params = value.split(',');

        List<String> result = new List<String>();
        for (String param : params) {
            param = param.replace('\'','');
            param = param.replace(',','');
            param = param.trim();
            result.add(param);
        }
        return result;
    }

    global static String replaceResourceReference(String value, String namespace) {
        if (value != null && value.indexOf('$Resource.') >= 0) {
            Integer startIndex = value.indexOfIgnoreCase('$Resource.');
            Integer endIndex = value.indexOf('/');
            if (endIndex < 0) endIndex = value.length();
            String resourceName = value.substring(startIndex+10,endIndex);
            if (resourceName.indexOf('__') < 0 && !String.isEmpty(namespace)) {
                resourceName = namespace.toLowerCase() + '__' + resourceName;
            }
            else if (resourceName.indexOf('__') > 0) {
                resourceName = resourceName.substringBefore('__').tolowercase() + '__' + resourcename.substringAfter('__');
            }

            String newValue = value.substring(0,startIndex) + resourceName + value.substring(endIndex);
            System.debug(newValue);
                String rsr = PageReference.forResource(newValue).getUrl();
                        System.debug(rsr);
                if (rsr.indexOf('?') > 0) rsr = rsr.substring(0,rsr.indexOf('?'));
            value = rsr;
        }
        return value;
    }

    global class Resource {
        String hashcode;
        String url;
        String type;
    }
}