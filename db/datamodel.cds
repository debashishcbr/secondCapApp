
// type pools - include program
using { devc.common as common } from './common';
using { cuid,Currency } from '@sap/cds/common';
using { Attachments  } from '@cap-js/attachments';


// unique name for project
namespace devc.db;

// context - grouping of data
context master {

    entity businesspartner {
// datable table - devc_db_businesspartner
        key NODE_KEY     :common.guid @title : '{i18n>partner}';
            BP_ROLE      :String(2);
            EMAIL_ADDRESS:String(125);
            PHONE_NUMBER :String(32);
            FAX_NUMBER   :String(32);
            WEB_ADDRESS  :String(44);
            COMPANY_NAME :String(250) @title : '{i18n>company}';
            BP_ID        :String(32);
         // foreign key relationship
            ADDRESS_GUID : Association to one address ;
    }

    entity address {
        key NODE_KEY        :common.guid;
            CITY            :String(50) @title : '{i18n>city}';            
            POSTAL_CODE     :String(8);
            STREET          :String(44);
            BUILDING        :String(128);
            COUNTRY         :String(44) @title : '{i18n>country}';
            ADDRESS_TYPE    :String(44);
            VAL_START_DATE  :Date;
            VAL_END_DATE    :Date;
            LATITUDE        :Decimal;        
            LONGITUDE       :Decimal;    
         // backward relationship - NOT Mandatory
         // $self is a predicate provided by capm to refer current table primary key
            businesspartner : Association to one businesspartner on
                     businesspartner.ADDRESS_GUID = $self ;   //NODE_KEY               
    }   

    entity employees : cuid{
        //key NODE_KEY       :common.guid;
            nameFirst      :String(256); 
            nameMiddle     :String(256); 
            nameLast       :String(256);             
            nameInitials   :String(40); 
            sex            :common.gender; 
            language       :String(1);            
            phoneNumber    :common.phoneNumber; 
            email          :common.email;
            loginName      :String(12);
            Currency       :Currency;
            salaryAmount   :common.amountT;
            accountNumber  :String(40);
            bankId         :String(40);
            bankName       :String(64);
            country        :String(3);                  
    }    

    entity product {
        key NODE_KEY        :common.guid;
            PRODUCT_ID      :String(28); 
            TYPE_CODE       :String(2); 
            CATEGORY        :String(32);       
        // capm will automatically create a text table with this field        
            DESCRIPTION     :localized String(255) @title : '{i18n>description}'; 
            SUPPLIER_GUID   :Association to one businesspartner; 
            TAX_TARIF_CODE  :Integer;            
            MEASURE_UNIT    :String(2); 
            WEIGHT_MEASURE  :Decimal(5,2)  @(Semantic.quantity.unit: 'WEIGHT_UNIT');
            WEIGHT_UNIT     :String(2);
            CURRENCY        :Currency;
            PRICE           :Decimal(15,2) @(Semantic.amount.currencyCode:'CURRENCY_code');
            WIDTH           :Decimal(5,2)  @(Semantic.quantity.unit: 'DIM_UNIT');
            HEIGHT          :Decimal(5,2)  @(Semantic.quantity.unit: 'DIM_UNIT');
            DEPTH           :Decimal(5,2)  @(Semantic.quantity.unit: 'DIM_UNIT');
            DIM_UNIT        :String(2);
    }     

     entity StatusCode {
        key STATUS: String(1);
            text: String(10);
     }

      entity student:cuid {
      key studentId      :Integer;
          nameFirst      :String(256); 
          nameMiddle     :String(256); 
          nameLast       :String(256);             
          nameInitials   :String(40); 
          sex            :common.gender; 
          language       :String(1);            
          phoneNumber    :common.phoneNumber; 
          email          :common.email;     
          subscriptionId : Association to one subscription;   
     }      

    entity subscription : cuid{
        lendingNo      :Integer;        
        bookName       :String(125);
        author         :String(125); 
        sub_start_date :Date;
        sub_end_date   :Date;
    }      
      
}

context transaction {

    entity purchaseorder :common.Amount,cuid {
        //key NODE_KEY         : common.guid @title : '{i18n>po_key}';
            PO_ID            : String(28) @title : '{i18n>po_id}'; 
            PARTNER_GUID     : Association to one master.businesspartner; 
            LIFECYCLE_STATUS : String(1) @title : '{i18n>status}';
          //  OVERALL_STATUS   : String(1) @title : '{i18n>status}';
            OVERALL          : Association to one master.StatusCode @title : '{i18n>status}';
            NOTE             : String(255) @title : '{i18n>note}';
            Items            : Association to many poitems on 
                               Items.PARENT_KEY = $self;
            attachments       : Composition of many Attachments;                               
    }      

    entity poitems :common.Amount,cuid{
        //key NODE_KEY        : common.guid;
            PARENT_KEY      : Association to one purchaseorder;
            PO_ITEM_POS     : Integer @title : '{i18n>item_pos}';
            PRODUCT_GUID    : Association to one master.product;   
    }
    
}