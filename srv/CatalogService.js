import cds from '@sap/cds'

export class CatalogService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProductSet, BusinessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseOrderItemSet } = cds.entities('CatalogService')


  this.on('getDefaultOrderData', async(req) => {
    return {  OVERALL_STATUS : 'P', LIFECYCLE_STATUS : 'N' }     
    
  }) 
  this.on('getMostExpOrders', async (req) => { 

    const top = req.data.top;
    //CDS QL
    const tx = cds.tx(req);

    // top 3 most expensive most expensive orders
    const response = await tx.read(PurchaseOrderSet).orderBy({
       GROSS_AMOUNT: 'desc'

 

      }).limit(top);

      return response;
   })
  this.on('boost', async(req) =>{

    let primaryKey = req.params[0];

    console.log('aaya kya',JSON.stringify(primaryKey));

    //CDS QL
    // get the cds transaction api object

    const tx = cds.tx(req);

   try { 

    await tx.update(PurchaseOrderSet).with({
      GROSS_AMOUNT : {'+=':5000},
      NOTE : 'boosted !!'

    }).where(primaryKey);

    // quey updated data from database

    return await tx.read(PurchaseOrderSet).where(primaryKey);

   }catch(error){
    return new Error(error);  
   };
    

  })
  
  this.before (['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
    console.log('Before CREATE/UPDATE EmployeeSet', req.data)
    
   // var qry = cds.tx(req.query);
    const grossAmount = req.data && req.data.salaryAmount ? req.data.salaryAmount: '';

    if (parseFloat(grossAmount) >= 1000000){
      req.error(500,"hey amigo !! salary too high")
    }

  })
  this.after ('READ', EmployeeSet, async (employeeSet, req) => {
    console.log('After READ EmployeeSet', employeeSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
  })
  this.after ('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ BusinessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], AddressSet, async (req) => {
    console.log('Before CREATE/UPDATE AddressSet', req.data)
  })
  this.after ('READ', AddressSet, async (addressSet, req) => {
    console.log('After READ AddressSet', addressSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
    //console.log('After READ PurchaseOrderSet', purchaseOrderSet)

    for(let i = 0;i<purchaseOrderSet.length;i++){
      if(!purchaseOrderSet[i].NOTE){
          purchaseOrderSet[i].NOTE = 'Not found !!';

      }
    }
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderItemSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderItemSet', req.data)
  })
  this.after ('READ', PurchaseOrderItemSet, async (purchaseOrderItemSet, req) => {
    console.log('After READ PurchaseOrderItemSet', purchaseOrderItemSet)
  })


  return super.init()
}}
