public with sharing class KnowledgeArticlesUpdateController {
   
    @AuraEnabled(cacheable=true)
    public static List<knowledgeArticleRecordTypeWrapper> getArticleRecordTypes(){
        try {

            List<knowledgeArticleRecordTypeWrapper> kWrapperList = new List<knowledgeArticleRecordTypeWrapper>();
            List<RecordType> lstArticles = [SELECT Id, Name FROM RecordType WHERE SobjectType='Knowledge__kav'];

            if(!lstArticles.isEmpty()){
                for (RecordType tem : lstArticles) {
                    knowledgeArticleRecordTypeWrapper nkWrapper = new knowledgeArticleRecordTypeWrapper();
                    nkWrapper.recordTypeId = tem.Id;
                    nkWrapper.recordTypeName = tem.Name;
                    kWrapperList.add(nkWrapper);
                }
            }
            return kWrapperList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getAllArticles(String providerKey, String recTypeKey){

       return [SELECT Id, OwnerId, PublishStatus, VersionNumber, Title, UrlName, Summary, ArticleNumber, RecordTypeId, Answer__c, Question__c, Provider__c FROM Knowledge__kav WHERE Provider__c =: providerKey AND RecordTypeId =: recTypeKey];
            
    }

    @AuraEnabled(cacheable=true)
    public static List<KnowledgeArticlesFieldsWrapper> getFields(){
            try {
                    List<KnowledgeArticlesFieldsWrapper> fkWrapperList = new List<KnowledgeArticlesFieldsWrapper>();

                    Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Knowledge__kav').getDescribe().fields.getMap();

                    for(Schema.SObjectField sfield : fieldMap.Values())
                    {
                        schema.describefieldresult dfield = sfield.getDescribe();

                        if(dfield.isCreateable() && dfield.isUpdateable()){
                                KnowledgeArticlesFieldsWrapper nfkWrapper = new KnowledgeArticlesFieldsWrapper();
                                nfkWrapper.labelValue = dfield.getLabel();
                                nfkWrapper.apiValue = dfield.getname();
                                fkWrapperList.add(nfkWrapper);
                        }
                    }   
                    return fkWrapperList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Knowledge__kav> updateTextValue(String textRepKey,String textUpKey,String fieldKey, String providerKey, String recTypeKey){
        try {

            String replaceValue = textRepKey;
            String updateValue = textUpKey;
            String objectName = 'Knowledge__kav';
            string status = 'Draft';
            String fieldlabel = fieldKey;
            String upVal;

            String query = 'SELECT '+ fieldlabel +' FROM Knowledge__kav Where PublishStatus=:status AND Provider__c =: providerKey AND RecordTypeId =: recTypeKey';
            System.debug(query);
            List<Knowledge__kav> lstArticles = database.query(query);
            System.debug(lstArticles);
            for(Knowledge__kav a: lstArticles){
                Object val = a.get(fieldlabel);
                String value = (String) val;
                if(value.contains(replaceValue)){
                    upVal = value.replace(replaceValue,updateValue);
                    a.put(fieldlabel,upVal);
                }
                
            }

            System.debug(lstArticles);
            update lstArticles;
            return lstArticles;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}