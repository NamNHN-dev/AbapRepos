@AbapCatalog.sqlViewName: 'ZTESTCLUSTER'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cluster kit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  representativeKey: 'Salesorder',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view ZI_ClusterKit with parameters
    P_ExchangeRateType : kurst,
    P_DisplayCurrency  : vdm_v_display_currency as select from ZR_SALESDOC_EXTENSION as SE
    left outer join I_SalesOrderItemCube (
      P_ExchangeRateType: $parameters.P_ExchangeRateType,
      P_DisplayCurrency: $parameters.P_DisplayCurrency
        ) as SO on SE.SalesOrder = SO.SalesOrder
    left outer join ZR_CLUSTER        as Clus       on ZZClusterIdSDH  = Clus.ClusterId
    left outer join ZR_CLUSTER_PRICE        as ClusP       on ZZClusterIdSDH  = ClusP.ClusterId
    left outer join ZX_ProblemCode_C as PC on SE.SalesOrder = PC.SalesOrder


{
    key SO.SalesOrder,
    ClusP.Price,
    ClusP.PriceUnit,
    PC.ZZProblemCodeSDI,
    SE.ZZClusterIdSDH,
    Clus.Description,
    Clus.Modem as PricingMethod,
    Clus._price.PriceUnit as ClusterCurrency,
    SO.BillToParty,
    SO._BillToParty.CustomerName,
    SO.OrderQuantityUnit,
    SO._BillToParty.BPAddrStreetName as Address1,
    SO.TransactionCurrency as Currency,
    SO.Product,
    SO.FiscalYear,
    SO.FiscalPeriod,
    SO.DisplayCurrency,
    @DefaultAggregation: #SUM
    @Semantics.amount.currencyCode: 'DisplayCurrency'
    SO.NetAmountInDisplayCurrency,
    SO.SalesOrderItemText,
    SO.ConfdDelivQtyInOrderQtyUnit,
    SO.SalesOrderDateYearMonth,
    SO.PriceDetnExchangeRate,
    SO.BaseUnit,
    SE.ZZRFHoursSDH,
    SO._SalesOrder,
    SO._OrderQuantityUnit,
    SO._TransactionCurrency,
    SO._Product,
    SO._BaseUnit

}
