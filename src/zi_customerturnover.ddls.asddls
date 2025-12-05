@AbapCatalog.sqlViewName: 'ZCUSTURNOVER01'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Turnover'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  representativeKey: 'SoldToParty',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER, 
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view ZI_CustomerTurnover 
  with parameters
    P_ExchangeRateType : kurst,
    P_DisplayCurrency  : vdm_v_display_currency
as select from ZI_CustCustom(
        P_ExchangeRateType  : $parameters.P_ExchangeRateType,
        P_DisplayCurrency   : $parameters.P_DisplayCurrency
        ) as CT
{
    key CT.SoldToParty,
    SoldToPartyName,
    _SoldToParty,
    DisplayCurrency,     
    SalesOrderDateYearMonth,
    SalesOrderDate,

@DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
    sum(NetAmountHC) as NetAmountHC,
    
@DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
    sum(TaxAmountHC) as TaxAmountHC,
@DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'    
    (NetAmountHC + TaxAmountHC) as TotalAmount
    
}
group by
    SoldToParty,
    SoldToPartyName,
    DisplayCurrency,
    SalesOrderDateYearMonth,
    SalesOrderDate,
    TaxAmountHC,
    NetAmountHC

