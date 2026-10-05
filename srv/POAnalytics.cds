using { devc.cds as spiderman} from '../db/CDSView';

service POAnalytics @(path:'POAnalytics'){

    entity PurchaseAnalytics as projection on spiderman.CDSView.POWorklist;

}

// block 1
// first block enables aggregate functions, crucial for fiori app development
// tools to properly recognize the support for ALP app

annotate  POAnalytics.PurchaseAnalytics with @(
        Aggregation.ApplySupported: {
        Transformations: [
            'aggregate',
            'topcount',
            'bottomcount',
            'identity',
            'concat',
            'groupby',
            'filter',
            'expand',
            'search'
        ],
         // x axis
        GroupableProperties: [
            CompanyName,
            Country,
            Status,
            ProuctCategory,
            ProductName
        ],
         // y axis
        AggregatableProperties: [
            {$Type : 'Aggregation.AggregatablePropertyType', Property: GrossAmount},
            {$Type : 'Aggregation.AggregatablePropertyType', Property: TaxAmount}

        ]
        
    },

Analytics.AggregatedProperty #totalAmout: {
    $Type : 'Analytics.AggregatedPropertyType',
    Name: 'TotalAmount',
    AggregationMethod: 'sum',
    AggregatableProperty: GrossAmount,
    ![@Common.Label]: 'Gross Total'

},

Analytics.AggregatedProperty #avgTax: {
    $Type : 'Analytics.AggregatedPropertyType',
    Name: 'AverageTax',
    AggregationMethod: 'avg',
    AggregatableProperty: TaxAmount,
    ![@Common.Label]: 'Average Tax'

}
);


// block 2
// second block is for displaying the chart in middle of ALP
// default configuration for y-axis and x-axis
annotate  POAnalytics.PurchaseAnalytics with @(
    UI.Chart: {
        $Type: 'UI.ChartDefinitionType',
        Title: 'Total Purchase from Company',
        ChartType: #Column,
        Dimensions: [
            CompanyName,
            Country,
            ProuctCategory,
            ProductName,
            CurrencyCode
        ],
        DimensionAttributes: [
            {
                $Type: 'UI.ChartDimensionAttributeType',
                Dimension: CompanyName,
                Role: #Category
            }
        ],
        DynamicMeasures : [
            @Analytics.AggregatedProperty#totalAmout,
            @Analytics.AggregatedProperty#avgTax

        ],
        MeasureAttributes:[{
            $Type: 'UI.ChartMeasureAttributeType',
            DynamicMeasure: @Analytics.AggregatedProperty#totalAmout,
            Role: #Axis1
        }]
    },
    //  default configuration when the app loads
    UI.PresentationVariant: {
        $Type: 'UI.PresentationVariantType',
        Visualizations:[
            @UI.Chart 
        ]

    },

    UI.LineItem:[        
       { $Type: 'UI.DataField', Value: PurchaseOrderId},
       { $Type: 'UI.DataField', Value: ProuctCategory},
       { $Type: 'UI.DataField', Value: ProductName},
       { $Type: 'UI.DataField', Value: GrossAmount},
       { $Type: 'UI.DataField', Value: TaxAmount},
       { $Type: 'UI.DataField', Value: NetAmount},
    ],

    UI.SelectionFields :[
        CompanyName,
        Country,
        ProuctCategory,
        CurrencyCode_code

    ]
);

// block 3
// third block is for displaying visual filter
annotate POAnalytics.PurchaseAnalytics with @(
    UI.Chart #vfCountry:{
        $Type : 'UI.ChartDefinitionType',
        ChartType: #Bar,
        Dimensions: [Country],
        DynamicMeasures:[@Analytics.AggregatedProperty#totalAmout],
        DimensionAttributes:[{
           $Type : 'UI.ChartDimensionAttributeType',
           Dimension: Country,
           Role: #Category
        }],
        MeasureAttributes: [{
            $Type: 'UI.ChartMeasureAttributeType',
            Measure: GrossAmount,
            Role: #Axis1
        }]
    },

    UI.PresentationVariant #vfpvCountry: {
        $Type: 'UI.PresentationVariantType',
        Visualizations: [@UI.Chart#vfCountry]
    }

    
){ Country @Common.ValueList #vfvlCountry :{
    $Type: 'Common.ValueListType',
    CollectionPath: 'PurchaseAnalytics',
    Parameters: [{
        $Type: 'Common.ValueListParameterInOut',
        LocalDataProperty: Country,
        ValueListProperty: 'Country'
        }],
    PresentationVariantQualifier:  'vfpvCountry'  
}
} ;

// annotate POAnalytics.PurchaseAnalytics with @(
//     UI.Chart #vfCurrency:{
//         $Type : 'UI.ChartDefinitionType',
//         ChartType: #Bar,
//         Dimensions: [CurrencyCode],
//         DynamicMeasures:[@Analytics.AggregatedProperty#avgTax],
//         DimensionAttributes:[{
//            $Type : 'UI.ChartDimensionAttributeType',
//            Dimension: CurrencyCode,
//            Role: #Category
//         }],
//         MeasureAttributes: [{
//             $Type: 'UI.ChartMeasureAttributeType',
//             Measure: TaxAmount,
//             Role: #Axis1
//         }]
//     },

//     UI.PresentationVariant #vfpvCurrency: {
//         $Type: 'UI.PresentationVariantType',
//         Visualizations: [@UI.Chart#vfCurrency]
//     }

    
// ){ CurrencyCode @Common.ValueList #vfvlCurrency :{
//     $Type: 'Common.ValueListType',
//     CollectionPath: 'PurchaseAnalytics',
//     Parameters: [{
//         $Type: 'Common.ValueListParameterInOut',
//         LocalDataProperty: Currency,
//         ValueListProperty: 'Currency'
//         }],
//     PresentationVariantQualifier:  'vfpvCurrency'  
// }
// } ;
