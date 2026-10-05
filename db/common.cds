using { Currency } from '@sap/cds/common';

namespace devc.common;

// my own data type - domain
type guid: String(32);

type gender: String(1) enum {
 male = 'M';
 female = 'F';
 undisclosed = 'U';
};


type phoneNumber: String(30);
type email: String(250);
//CURR type field - reference field CUKY
//QUANT - unit
type amountT: Decimal(10,2) @(
    Semantic.amount.currencyCode: 'Currency'
);

aspect Amount :{
    GROSS_AMOUNT : Decimal(15, 2) @(Semantic.amount.currency: 'CURRENCY_code',title : '{i18n>gross_amount}') ;
    NET_AMOUNT   : Decimal(15, 2) @(Semantic.amount.currency: 'CURRENCY_code',title : '{i18n>net_amount}') ;
    TAX_AMOUNT   : Decimal(15, 2) @(Semantic.amount.currency: 'CURRENCY_code',title : '{i18n>tax_amount}') ;
    CURRENCY     : Currency @title : '{i18n>currency_code}';
}