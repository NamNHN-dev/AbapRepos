@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Document Item - Custom'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MDI_Custom
  as select from I_MaterialDocumentItem_2
{
  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,
      GoodsMovementType,
      FiscalYearVariant,
      PostingDate,
      PurchaseOrder,
      PurchaseOrderItem,
      DocumentDate,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      QuantityInEntryUnit,
      EntryUnit,
      CompanyCode,

      // Custom fields
      cast(concat('00', cast(MaterialDocumentItem as abap.char( 4 ))) as abap.numc( 6 )) as CustomReferenceDocumentItem,

      // associations
      _MaterialDocumentHeader
}
