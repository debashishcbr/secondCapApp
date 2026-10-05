import cds from '@sap/cds'

export class myservice extends cds.ApplicationService { init() {


  this.on ('employee', async (req) => {
    console.log('employee service call');
    return { 'name'    : 'debashish choudhury',
             'gender'  : 'Male',
             'address' : 'Canberra',
             'mobile'  : '+61470208364', 
    }
           
     
  }),

    this.on ('story', async (req) => {
    console.log('On story', req.data)
   
    let storyType =  req.data.name ; //req.params[0];
    //console.log(req.query.name);
    switch (storyType){
     case 'crow' :
     return "once upon a time there was a thirsty crow, it was looking for water in summer.." ;
     break;
     case 'king':
     return "once upon a time there was a kind king, he lived in Awadh..";
     break;     
     default:
     return "please send parameter as ?name=type e.g. king,crow" ;
     break;     
     
    }

  })

  return super.init()
}}
