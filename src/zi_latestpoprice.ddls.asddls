@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest PO price in change document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LATESTPOPRICE
  as select from I_PurOrdChangeDocumentItem as PurOrdChangeDocumentItem
    inner join   ZI_LATESTCHANGEDOC         as LatestChangeDoc on  PurOrdChangeDocumentItem.PurchaseOrder               = LatestChangeDoc.PurchaseOrder
                                                               and PurOrdChangeDocumentItem.ChangeDocObjectClass        = LatestChangeDoc.ChangeDocObjectClass
                                                               and PurOrdChangeDocumentItem.DatabaseTable               = LatestChangeDoc.DatabaseTable
                                                               and PurOrdChangeDocumentItem.ChangeDocTableKey           = LatestChangeDoc.ChangeDocTableKey
                                                               and PurOrdChangeDocumentItem.ChangeDocDatabaseTableField = LatestChangeDoc.ChangeDocDatabaseTableField
                                                               and PurOrdChangeDocumentItem.ChangeDocItemChangeType     = LatestChangeDoc.ChangeDocItemChangeType
                                                               and PurOrdChangeDocumentItem.ChangeDocument              = LatestChangeDoc.LatestChangeDocument
{
  key PurOrdChangeDocumentItem.PurchaseOrder,
  key PurOrdChangeDocumentItem.ChangeDocTableKey,
  key PurOrdChangeDocumentItem.ChangeDocItemChangeType,
      PurOrdChangeDocumentItem.ChangeDocument,
      PurOrdChangeDocumentItem.ChangeDocObjectClass,
      PurOrdChangeDocumentItem.DatabaseTable,
      PurOrdChangeDocumentItem.ChangeDocDatabaseTableField,
      PurOrdChangeDocumentItem.ChangeDocPreviousUnit,
      PurOrdChangeDocumentItem.ChangeDocNewUnit,
      PurOrdChangeDocumentItem.ChangeDocPreviousCurrency,
      PurOrdChangeDocumentItem.ChangeDocNewCurrency,
      PurOrdChangeDocumentItem.ChangeDocPreviousFieldValue,
      PurOrdChangeDocumentItem.ChangeDocNewFieldValue,
      PurOrdChangeDocumentItem.PurchaseOrderType,
      PurOrdChangeDocumentItem.PurchasingOrganization,
      PurOrdChangeDocumentItem.PurchasingGroup
}

where
      PurOrdChangeDocumentItem.DatabaseTable               = 'EKPO'
  and PurOrdChangeDocumentItem.ChangeDocDatabaseTableField = 'NETPR'
