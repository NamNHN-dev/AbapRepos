@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest Change Doc per Keys'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LATESTCHANGEDOC
  as select from I_PurOrdChangeDocumentItem as PurOrdChangeDocumentItem
{
  PurOrdChangeDocumentItem.PurchaseOrder               as PurchaseOrder,
  PurOrdChangeDocumentItem.ChangeDocObjectClass        as ChangeDocObjectClass,
  PurOrdChangeDocumentItem.DatabaseTable               as DatabaseTable,
  PurOrdChangeDocumentItem.ChangeDocTableKey           as ChangeDocTableKey,
  PurOrdChangeDocumentItem.ChangeDocDatabaseTableField as ChangeDocDatabaseTableField,
  PurOrdChangeDocumentItem.ChangeDocItemChangeType     as ChangeDocItemChangeType,
  max(PurOrdChangeDocumentItem.ChangeDocument)         as LatestChangeDocument
}
group by
  PurchaseOrder,
  ChangeDocObjectClass,
  DatabaseTable,
  ChangeDocTableKey,
  ChangeDocDatabaseTableField,
  ChangeDocItemChangeType
