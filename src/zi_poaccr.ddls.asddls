@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Accrued - CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_POAccr
  as select from    ZI_POITEM_CUSTOM     as POItem

    left outer join ZI_MDI_Custom        as GoodsReceipt       on  POItem.PurchaseOrder           = GoodsReceipt.PurchaseOrder
                                                               and POItem.PurchaseOrderItem       = GoodsReceipt.PurchaseOrderItem
                                                               and GoodsReceipt.GoodsMovementType = '101'

    left outer join I_CompanyCode        as CompanyCode        on POItem.CompanyCode = CompanyCode.CompanyCode

    left outer join I_FiscalCalendarDate as FiscalCalendarDate on  GoodsReceipt.FiscalYearVariant = FiscalCalendarDate.FiscalYearVariant
                                                               and GoodsReceipt.PostingDate       = FiscalCalendarDate.CalendarDate

    left outer join I_JournalEntryItem   as JournalEntryItem   on  GoodsReceipt.MaterialDocument            = JournalEntryItem.ReferenceDocument
                                                               and GoodsReceipt.CustomReferenceDocumentItem = JournalEntryItem.ReferenceDocumentItem
                                                               and GoodsReceipt.MaterialDocumentYear        = JournalEntryItem.FiscalYear
                                                               and GoodsReceipt.CompanyCode                 = JournalEntryItem.CompanyCode
                                                               and JournalEntryItem.Ledger                  = '0L'
                                                               and JournalEntryItem.ReferenceDocumentType   = 'MKPF'
                                                               and (
                                                                  JournalEntryItem.GLAccount                = '0000311900'
                                                                  or JournalEntryItem.GLAccount             = '0000311910'
                                                                  or JournalEntryItem.GLAccount             = '0000311920'
                                                                  or JournalEntryItem.GLAccount             = '0000902030'
                                                                )

    left outer join ZI_LATESTPOPRICE     as LatestPOPrice      on  POItem.PurchaseOrder                  = LatestPOPrice.PurchaseOrder
                                                               and POItem.CustomDocTableKey              = LatestPOPrice.ChangeDocTableKey
                                                               and LatestPOPrice.ChangeDocItemChangeType = 'U'
{
  key POItem.PurchaseOrder,
  key POItem.PurchaseOrderItem,

      POItem._PurchaseOrder.Supplier,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      POItem.OrderQuantity,
      POItem.PurchaseOrderQuantityUnit,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      POItem.NetPriceAmount,
      POItem.DocumentCurrency,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      @DefaultAggregation: #SUM
      POItem.NetAmount,
      
      GoodsReceipt.PostingDate,
      GoodsReceipt.DocumentDate,
      GoodsReceipt._MaterialDocumentHeader.CreationDate,
      GoodsReceipt._MaterialDocumentHeader.CreationTime,
      GoodsReceipt.MaterialDocument,
      GoodsReceipt.MaterialDocumentYear,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      cast(
      cast( POItem.NetPriceAmount as abap.dec( 13, 2 ) )
      * GoodsReceipt.QuantityInEntryUnit
      as abap.curr( 13, 2 )
      )                    as ReceiptAmt_FC,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(
      cast( POItem.NetPriceAmount as abap.dec( 13, 2 ) )
      * GoodsReceipt.QuantityInEntryUnit
      * POItem._PurchaseOrder.ExchangeRate
      as abap.curr( 13, 2 )
      )                    as ReceiptAmt_HC,

      FiscalCalendarDate.FiscalPeriod,

      CompanyCode.Currency as CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      @DefaultAggregation: #SUM
      case
        when JournalEntryItem.GLAccount = '0000311900'
            and JournalEntryItem.ReferenceDocumentItem = concat('00', GoodsReceipt.MaterialDocumentItem)
        then
            abs( JournalEntryItem.AmountInTransactionCurrency )
        else
            cast ( 0.00 as abap.curr( 23, 2 ))
      end                  as AC311900,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      @DefaultAggregation: #SUM
      case
        when JournalEntryItem.GLAccount = '0000311910'
            and JournalEntryItem.ReferenceDocumentItem = concat('00', GoodsReceipt.MaterialDocumentItem)
        then
            abs( JournalEntryItem.AmountInTransactionCurrency )
        else
            cast ( 0.00 as abap.curr( 23, 2 ))
      end                  as AC311910,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      @DefaultAggregation: #SUM
      case
        when JournalEntryItem.GLAccount = '0000311920'
            and JournalEntryItem.ReferenceDocumentItem = concat('00', GoodsReceipt.MaterialDocumentItem)
        then
            abs( JournalEntryItem.AmountInTransactionCurrency )
        else
            cast ( 0.00 as abap.curr( 23, 2 ))
      end                  as AC311920,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      @DefaultAggregation: #SUM
      case
        when JournalEntryItem.GLAccount = '0000902030'
            and JournalEntryItem.ReferenceDocumentItem = concat('00', GoodsReceipt.MaterialDocumentItem)
        then
            abs( JournalEntryItem.AmountInTransactionCurrency )
        else
            cast ( 0.00 as abap.curr( 23, 2 ))
      end                  as AC902030,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      @DefaultAggregation: #SUM
      case
        when LatestPOPrice.ChangeDocPreviousFieldValue is not null
        then cast(LatestPOPrice.ChangeDocPreviousFieldValue as abap.curr( 11, 2 )) - cast (LatestPOPrice.ChangeDocNewFieldValue as abap.curr(11, 2))
        else cast (0.00 as abap.curr( 11, 2 ))
      end                  as PurVariance,

      POItem._PurchaseOrder.PurchaseOrderDate,

      POItem._PurchaseOrder._Supplier
}
where
  POItem._PurchaseOrder.PurchaseOrderType = 'NB'
