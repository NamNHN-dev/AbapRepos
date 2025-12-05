@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item - Custom'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_POITEM_CUSTOM
  as select from I_PurchaseOrderItemAPI01
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      CompanyCode,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      OrderQuantity,
      PurchaseOrderQuantityUnit,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      NetPriceAmount,
      DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      NetAmount,
      /* Associations */
      _PurchaseOrder,
      // custom
      concat(concat('100', PurchaseOrder), PurchaseOrderItem) as CustomDocTableKey
}
