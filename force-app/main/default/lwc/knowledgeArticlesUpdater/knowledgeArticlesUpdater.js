import { LightningElement, api, track, wire } from 'lwc';
import getAllArticles from '@salesforce/apex/KnowledgeArticlesUpdateController.getAllArticles';
import getArticleRecordTypes from '@salesforce/apex/KnowledgeArticlesUpdateController.getArticleRecordTypes';
import getFields from '@salesforce/apex/KnowledgeArticlesUpdateController.getFields';
import updateTextValue from '@salesforce/apex/KnowledgeArticlesUpdateController.updateTextValue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const DELAY = 300;

const columns = [
    { label: 'Id', fieldName: 'Id' },
    { label: 'Knowledge Article Id', fieldName: 'KnowledgeArticleId' },
    { label: 'OwnerId', fieldName: 'OwnerId' },
    { label: 'PublishStatus', fieldName: 'PublishStatus' },
    { label: 'VersionNumber', fieldName: 'VersionNumber' },
    { label: 'Title', fieldName: 'Title' },
    { label: 'UrlName', fieldName: 'UrlName' },
    { label: 'Summary', fieldName: 'Summary' },
    { label: 'ArticleNumber', fieldName: 'ArticleNumber' },
    { label: 'RecordTypeId', fieldName: 'RecordTypeId' },
    { label: 'Answer__c', fieldName: 'Answer__c' },
    { label: 'Question__c', fieldName: 'Question__c' },
    { label: 'Provider__c', fieldName: 'Provider__c' },
];

export default class KnowledgeArticlesUpdater extends LightningElement {

    columns = columns;
    articles;

    @track textRepValue;
    @track textUpValue;

    @track items = [];
    @track fielditems = [];

    @track providerKey;
    @track recTypeKey;

    @track fieldKey;
    @track textRepKey;
    @track textUpKey;

    @wire(getAllArticles,{providerKey:'$providerKey', recTypeKey:'$recTypeKey'}) wiredArticles;

    @wire(getArticleRecordTypes) articleTypes({ error, data }) {
        if (data) {
            let tempArray =[];
            for(var i=0; i<data.length; i++) {
               tempArray .push({ label: data[i].recordTypeName, value: data[i].recordTypeId});
            }   
            this.items = tempArray;                                            
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.log(error);
        }
    }

    @wire(getFields) wiredFields({error, data}) {
        if (data) {
            let tem =[];
            for(var i=0; i<data.length; i++) {
               tem .push({ label: data[i].labelValue, value: data[i].apiValue});
            }   
            this.fielditems = tem;                                            
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.log(error);
        }
    }

    // Combo Box - 1
    get recOptions() {
        return this.items;
    }

    // Combo Box - 2
    get providerOptions() {
        return [
            { label: 'JMH', value: 'JMH' },
            { label: 'DGT', value: 'DGT' },
        ];
    }

    //Combo Box -3
    get fieldOptions() {
        return this.fielditems;
    }
    
    handleRecordTypeChange(event) {
        this.recTypeKey = event.detail.value;
        console.log(this.recTypeKey);
    }

    handleProviderChange(event) {
        this.providerKey = event.detail.value;
        console.log(this.providerKey);
    }

    handleFieldChange(event){
        this.fieldKey = event.detail.value;
        console.log(this.fieldKey);
    }

    handleReplacingTextChange(event){
        window.clearTimeout(this.delayTimeout);

        const repKey = event.target.value;

        this.delayTimeout = setTimeout(() => {
           
            this.textRepKey = repKey;

        }, DELAY);

    }

    handleUpdateTextChange(event){
        window.clearTimeout(this.delayTimeout);

        const upKey = event.target.value;

        this.delayTimeout = setTimeout(() => {
           
            this.textUpKey = upKey;

        }, DELAY);
        
    }

    updateRecords(){
        updateTextValue({textRepKey:this.textRepKey, textUpKey:this.textUpKey, fieldKey:this.fieldKey})
        .then(result=>{
            let d = JSON.stringify(result);
            console.log('Knowledge Data Updated'+ JSON.stringify(result));
        })
        .catch(error=>{
            this.error = error;
            console.log('Data Update Error'+ this.error);
        });
        console.log("Updater method!");
    }

    handleUpdateRecord(){
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);

        const isComboCorrect = [...this.template.querySelectorAll('lightning-combobox')]
        .reduce((validSoFar, inputCombo) => {
            inputCombo.reportValidity();
            return validSoFar && inputCombo.checkValidity();
        }, true);

        if (isInputsCorrect && isComboCorrect) {
        //perform success logic
        console.log("Updater!");
        updateTextValue({textRepKey:this.textRepKey, textUpKey:this.textUpKey, fieldKey:this.fieldKey, providerKey:this.providerKey, recTypeKey:this.recTypeKey})
        .then(result=>{
            let d = JSON.stringify(result);
            console.log('Knowledge Data Updated'+ JSON.stringify(result));
            const evt = new ShowToastEvent({
                title: "Success!",
                message: "Congrats, KnowledgeArticles records has been successfully Updated!",
                variant: "success",
            });
            this.dispatchEvent(evt);

            this.template.querySelectorAll('lightning-input').forEach(element => {
                  element.value = null;     
            });

            this.template.querySelectorAll('lightning-combobox').forEach(element => {
                element.value = null;     
            });

            return refreshApex(this.wiredArticles);

        })
        .catch(error=>{
            this.error = error;
            console.log('Data Update Error'+ this.error);
        });
        console.log("Updater method!");
        }
        
    }

}