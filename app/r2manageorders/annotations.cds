using CatalogService as service from '../../srv/CatalogService';
annotate service.PurchaseOrderSet with @(

 // header info - title
   UI.HeaderInfo : {
      TypeName: 'Purchase Order',
      TypeNamePlural: 'Purchase Orders',
      Title: {Value:PO_ID},
      Description: {Value: PARTNER_GUID.COMPANY_NAME}
   },
 // selection fields
    UI.SelectionFields: [
         PO_ID,
         PARTNER_GUID.COMPANY_NAME,
         PARTNER_GUID.ADDRESS_GUID.COUNTRY,
         GROSS_AMOUNT,
         OVERALL_STATUS         
    ], 

// add columns to table - list report
   UI.LineItem: [ 
                 {
                 $Type : 'UI.DataField',
                  Value : PO_ID,
                },
                {
                 $Type : 'UI.DataField',
                  Value : PARTNER_GUID.COMPANY_NAME,
                },               
                {
                 $Type : 'UI.DataField',
                  Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
                },
                {
                 $Type : 'UI.DataField',
                  Value : GROSS_AMOUNT,
                },
                {
                    $Type : 'UI.DataFieldForAction',
                    Action : 'CatalogService.boost',
                    Label : 'boost',
                    Inline:true
                },
                {
                $Type : 'UI.DataField',
                 Value : OVERALL_STATUS,
                 Criticality:Color
                },                
   ],

   // tab strip
    UI.Facets: [
        {
            $Type : 'UI.CollectionFacet',
            Label: 'Details',
            Facets : [
              {
                  $Type : 'UI.ReferenceFacet',
                  Target : '@UI.Identification',
                  Label : 'Basic Info'
              },

              {
                  $Type : 'UI.ReferenceFacet',
                  Target : '@UI.FieldGroup#Ironman',
                  Label : 'Amount'
              },              
              {
                  $Type : 'UI.ReferenceFacet',
                  Target : '@UI.FieldGroup#batman',
                  Label : 'Additional Fields'
              },              
            ]
            ,

            
        },
        {
                  $Type : 'UI.ReferenceFacet',
                  Target : 'Items/@UI.LineItem',
                  Label : 'PO Items'
        }            
    ],

    UI.Identification:[
      {
          $Type : 'UI.DataField',
          Value : PO_ID,
      },
      {
          $Type : 'UI.DataField',
          Value : PARTNER_GUID_NODE_KEY,
      },
      {
          $Type : 'UI.DataField',
          Value : LIFECYCLE_STATUS,
      },
    ],

    UI.FieldGroup #Ironman: {
      Data: [
           {
               $Type : 'UI.DataField',
               Value : GROSS_AMOUNT,
           },      
           {
               $Type : 'UI.DataField',
               Value : NET_AMOUNT,
           },
           {
               $Type : 'UI.DataField',
               Value : TAX_AMOUNT,
           },
      ]
       
    },

    UI.FieldGroup #batman: {
      Data: [
         {
             $Type : 'UI.DataField',
             Value : CURRENCY_code,
         },
         {
             $Type : 'UI.DataField',
             Value : OVERALL_STATUS,
         },
         {
             $Type : 'UI.DataField',
             Value : NOTE,
         },
      ]
    }

);

annotate service.PurchaseOrderSet with {
  @Common :{ Text : NOTE }
  PO_ID;
  @Common : { Text: OVERALL.text,
              ValueList : {
                  $Type : 'Common.ValueListType',
                  CollectionPath: 'StatusCodeSet',
                  Parameters: [
                    {
                        $Type : 'Common.ValueListParameterInOut',
                        LocalDataProperty : OVERALL_STATUS,
                        ValueListProperty : 'STATUS'
                    }
                  ]
                  
              },
               ValueListWithFixedValues: true
              }
  OVERALL;
  @Common : { Text: PARTNER_GUID.COMPANY_NAME}
  @ValueList.entity : service.BusinessPartnerSet
  PARTNER_GUID;
};

annotate service.PurchaseOrderItemSet with{
  @Common : { Text : PRODUCT_GUID.DESCRIPTION }
  @ValueList.entity : service.ProductSet
  PRODUCT_GUID;
} ;


annotate service.StatusCodeSet with{
 @Common : { Text : text , Text.@UI.TextArrangement : #TextFirst}
 STATUS;
};


annotate service.PurchaseOrderItemSet with @(

  UI.HeaderInfo: {
       TypeName: 'PO Item',
       TypeNamePlural: 'PO Items',
       Title: {Value: PO_ITEM_POS},
       Description: {Value:PRODUCT_GUID.DESCRIPTION}
  },

  UI.Facets: [    
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.Identification',
            Label : 'Item Details'
        }         
  ],

  UI.Identification:[
      {
          $Type : 'UI.DataField',
          Value : PO_ITEM_POS,
      },
      {
          $Type : 'UI.DataField',
          Value : PRODUCT_GUID_NODE_KEY,
      },
      {
          $Type : 'UI.DataField',
          Value : GROSS_AMOUNT,
      },

      {
          $Type : 'UI.DataField',
          Value : NET_AMOUNT,
      },

      {
          $Type : 'UI.DataField',
          Value : CURRENCY_code,
      },            
    ],  

  UI.LineItem: [
                 {
                 $Type : 'UI.DataField',
                  Value : PO_ITEM_POS,
                },
                 {
                 $Type : 'UI.DataField',
                  Value : PRODUCT_GUID.DESCRIPTION,
                },                
                 {
                 $Type : 'UI.DataField',
                  Value : PARENT_KEY.GROSS_AMOUNT,
                },                
                 {
                 $Type : 'UI.DataField',
                  Value : PARENT_KEY.TAX_AMOUNT,
                },                

                 {
                 $Type : 'UI.DataField',
                  Value : PARENT_KEY.CURRENCY_code,
                },                
  ]
);

// value help definition for Business Partner
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification : [
      {
          $Type : 'UI.DataField',
          Value : COMPANY_NAME,
      },
    ]
);

// value help definition for Product Set
@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification : [
      {
          $Type : 'UI.DataField',
          Value : DESCRIPTION,
      },
    ]

);

