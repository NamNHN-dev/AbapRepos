@AbapCatalog.sqlViewName: 'ZCUSTURNOVER02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Turnover Custom'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_CustCustom with parameters 
    P_ExchangeRateType : kurst,
    P_DisplayCurrency  : vdm_v_display_currency
as select from I_SalesOrderItemCube(
        P_ExchangeRateType  : $parameters.P_ExchangeRateType,
        P_DisplayCurrency   : $parameters.P_DisplayCurrency
        )
{
    key SoldToParty,
    SoldToPartyName, 
    _SoldToParty,
    DisplayCurrency,     
    SalesOrderDate,
    SalesOrderDateYearMonth,
@DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
    sum(NetAmountInDisplayCurrency) as NetAmountHC,
@DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
    sum(TaxAmount) * PriceDetnExchangeRate as TaxAmountHC
}
group by
    SoldToParty,
    SoldToPartyName,
    DisplayCurrency,
    SalesOrderDate,
    PriceDetnExchangeRate,
    NetAmountInDisplayCurrency,
    SalesOrderDateYearMonth,
    TaxAmount
