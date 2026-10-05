import cds from '@sap/cds';


export class CDSService extends cds.ApplicationService { init() {

  const { ProductSet, ItemSet, PartnerSet } = cds.entities('CDSService')

  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    let aIds =  productSet.map( product => product.ProductId);
    const orderCount = await SELECT.from(ItemSet)
                             .columns('ProductKey',{func:'count',as:'purchCount'})
                             .where({'ProductKey': {in:aIds}})
                             .groupBy('ProductKey');
   // console.log('After READ ProductSet', productSet)
   for (let i = 0; i < productSet.length; i++) {
      
     const foundRecord = orderCount.find(wa => wa.ProductKey === productSet[i].ProductId);
           productSet[i].purchCount = foundRecord ? foundRecord.purchCount : 0;
        //  orderCount.find(wa => wa.ProductKey === productSet[i].ProductId)
        //  {
        //    productSet[i].purchCount = wa ? wa.purchCount : 0;
        //  }
     }

  })
  this.before (['CREATE', 'UPDATE'], ItemSet, async (req) => {
    console.log('Before CREATE/UPDATE ItemSet', req.data)
  })
  this.after ('READ', ItemSet, async (itemSet, req) => {
    console.log('After READ ItemSet', itemSet)
  })
  this.before (['CREATE', 'UPDATE'], PartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE PartnerSet', req.data)
  })
  this.after ('READ', PartnerSet, async (partnerSet, req) => {
    console.log('After READ PartnerSet', partnerSet)
  })


  return super.init()
}}
