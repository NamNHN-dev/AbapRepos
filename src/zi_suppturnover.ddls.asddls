@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Turn Over'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  representativeKey: 'BusinessPartner',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view entity ZI_SUPPTURNOVER as select from    I_BusinessPartner        as BP
    join            ZI_POAccr                as POAccr  on POAccr.Supplier = BP.BusinessPartner
    left outer join I_PurchaseOrderItemAPI01 as POItem  on  POItem.PurchaseOrder             =  POAccr.PurchaseOrder
                                                        and POItem.PurchaseOrderItem         =  POAccr.PurchaseOrderItem
                                                        and POItem.AccountAssignmentCategory != 'K'
    left outer join I_TaxCodeRate            as TaxCode on  POItem.TaxCode                    = TaxCode.TaxCode
                                                        and TaxCode.CndnRecordValidityEndDate > $session.system_date
{
  key  BP.BusinessPartner,
       POAccr._Supplier.BusinessPartnerName1,
       POAccr.DocumentCurrency,
       TaxCode.ConditionRateRatio,
       POAccr.CompanyCodeCurrency,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       @DefaultAggregation: #SUM
       cast(cast(POAccr.NetAmount as abap.dec(13,2)) * POItem._PurchaseOrder.ExchangeRate as abap.curr(13,2))             as Amount,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       @DefaultAggregation: #SUM
       cast(cast(POAccr.NetAmount as abap.dec(13,2)) * TaxCode.ConditionRateRatio as abap.curr(13,2)) as TaxAmount,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       @DefaultAggregation: #SUM
       case
      when TaxCode.ConditionRateRatio is not null
      then cast(
             cast(POAccr.NetAmount as abap.decfloat34)
             * ( 1 + get_numeric_value(TaxCode.ConditionRateRatio))
             * cast(POItem._PurchaseOrder.ExchangeRate as abap.decfloat34)
             as abap.curr(13,2)
           )
      else cast(cast(POAccr.NetAmount as abap.dec(13,2)) * POItem._PurchaseOrder.ExchangeRate as abap.curr(13,2))
    end as NetPurchaseAmount

}
group by
  BP.BusinessPartner,
  POAccr._Supplier.BusinessPartnerName1,
  POAccr.DocumentCurrency,
  POAccr.ReceiptAmt_HC,
  POAccr.CompanyCodeCurrency,
  TaxCode.ConditionRateRatio,
  POAccr.NetAmount,
  POItem._PurchaseOrder.ExchangeRate
