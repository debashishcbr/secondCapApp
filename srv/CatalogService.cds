using { devc.db.master,devc.db.transaction } from '../db/datamodel';

service CatalogService @(path: 'CatalogService', requires: 'authenticated-user'){
    //@readonly    
    entity EmployeeSet @(restrict : 
                        [ { grant: ['READ'], to: 'Display', where: 'bankName = $user.Spiderman'},
                          { grant: ['WRITE','DELETE'], to: 'Edit'}                            
                        ]
    )
    as projection on master.employees;
    entity ProductSet  as projection on master.product;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    entity StatusCodeSet as projection on master.StatusCode;
    entity PurchaseOrderSet @(odata.draft.enabled:true,
    Common.DefaultValuesFunction:'getDefaultOrderData')
     as projection on transaction.purchaseorder{
           *,
           case 
           when OVERALL.STATUS = 'A' then cast(3 as Integer)
           when OVERALL.STATUS = 'D' then cast(3 as Integer)
           when OVERALL.STATUS = 'X' then cast(1 as Integer)
           when OVERALL.STATUS = 'P' then cast(2 as Integer)
           when OVERALL.STATUS = 'N' then cast(2 as Integer)
           else cast(0 as Integer)
           end as Color: Integer
           }    
    actions{
        // instance bound action, primary key is passed
           @Common : { SideEffects : {
               $Type : 'Common.SideEffectsType',
               TargetProperties:['in/GROSS_AMOUNT']
           }, }
           action boost() returns PurchaseOrderSet
    }

    // get default value for purchase order ~ while creation
    function getDefaultOrderData() returns PurchaseOrderSet;
       // non instance bound  function - top3 most expensive
    function getMostExpOrders(top:Integer) returns many PurchaseOrderSet;
    entity PurchaseOrderItemSet as projection on transaction.poitems;

}
