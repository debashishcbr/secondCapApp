using { devc.db.master,devc.db.transaction  } from './datamodel';

namespace devc.cds;

context CDSView {

    define view ![POWorklist] as
     select from transaction.purchaseorder{
        key PO_ID                             as ![PurchaseOrderId],
        key Items.PO_ITEM_POS                 as ![ItemPosition],
            PARTNER_GUID.BP_ID                as ![SupplierId],
            PARTNER_GUID.COMPANY_NAME         as ![CompanyName],
            Items.GROSS_AMOUNT                as ![GrossAmount],
            Items.NET_AMOUNT                  as ![NetAmount],
            Items.TAX_AMOUNT                  as ![TaxAmount],
            Items.CURRENCY                    as ![CurrencyCode],
        //    OVERALL_STATUS                    as ![Status],
            OVERALL                           as ![Status],
            Items.PRODUCT_GUID.CATEGORY       as ![ProuctCategory],
            Items.PRODUCT_GUID.DESCRIPTION    as ![ProductName],
            PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country]            
     }


    define view ![ItemView] as
     select from transaction.poitems{
        key PARENT_KEY.PARTNER_GUID.NODE_KEY  as ![SupplierId],
        key PRODUCT_GUID.NODE_KEY             as ![ProductKey],
            CURRENCY                          as ![CurrencyCode],
            GROSS_AMOUNT                      as ![GrossAmount],
            NET_AMOUNT                        as ![NetAmount],
            TAX_AMOUNT                        as ![TaxAmount],
            PARENT_KEY.OVERALL                as ![Status],
            
     }

     // mixin - lazy loading  or on-demand join
    define view ![ProductView] as select from master.product
     mixin {
        PO_ORDER: Association to many  ItemView on PO_ORDER.ProductKey = $projection.ProductId
     } 
     into {
        key NODE_KEY     as ![ProductId],
            DESCRIPTION  as ![Description],
            CATEGORY     as ![Category],
            PRICE        as ![Price],
            SUPPLIER_GUID.COMPANY_NAME         as ![Vendor],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country], 
            // exposed association - data is loaded at runtime
            PO_ORDER     as ![To_Items]          
     }   

    // conjunction view
    define view CProductView as  select from ProductView
     {
       key ProductId,
           Country, 
           round(sum(To_Items.GrossAmount),2 )as ![TotalAmount],
           To_Items.CurrencyCode          
     }  group by ProductId,Country,To_Items.CurrencyCode;         


   // exercise on mixin - S13
   // design a view to  load data of business partners and on-demand load POs for selected bps
   define view PartnerList as select from master.businesspartner
   mixin  {
     Orders : Association to many  transaction.purchaseorder on  Orders.PARTNER_GUID = $self
   }
    into
    {
        key NODE_KEY              as ![PartnerKey],
            BP_ID                 as ![PartnerId],
            EMAIL_ADDRESS         as ![Email],
            PHONE_NUMBER          as ![Phone],
            COMPANY_NAME          as ![Commany],   
            Orders                as ![toOrders],
           // Orders.PO_ID          as ![OrderId],
           // Orders.OVERALL_STATUS as ![Status],             
    }


    
}
