using { devc.cds } from '../db/CDSView';

service CDSService @(path:'CDSService'){

  entity ProductSet as projection on cds.CDSView.ProductView{
    *,
    // plz show a virtual field to show number of buys for product
    virtual purchCount : Int16,
  };
  entity ItemSet    as projection on cds.CDSView.ItemView;
  entity PartnerSet as projection on cds.CDSView.PartnerList;
}
