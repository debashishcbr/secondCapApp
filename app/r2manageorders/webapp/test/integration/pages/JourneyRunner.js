sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"revisiontwo/r2manageorders/test/integration/pages/PurchaseOrderSetList.gen",
	"revisiontwo/r2manageorders/test/integration/pages/PurchaseOrderSetObjectPage.gen",
	"revisiontwo/r2manageorders/test/integration/pages/PurchaseOrderItemSetObjectPage.gen"
], function (JourneyRunner, PurchaseOrderSetListGenerated, PurchaseOrderSetObjectPageGenerated, PurchaseOrderItemSetObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('revisiontwo/r2manageorders') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSetListGenerated: PurchaseOrderSetListGenerated,
			onThePurchaseOrderSetObjectPageGenerated: PurchaseOrderSetObjectPageGenerated,
			onThePurchaseOrderItemSetObjectPageGenerated: PurchaseOrderItemSetObjectPageGenerated
        },
        async: true
    });

    return runner;
});

