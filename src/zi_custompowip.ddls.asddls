@AbapCatalog.sqlViewName: 'ZITEST02'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CUSTOM LISTING'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  representativeKey: 'ProductionOrder',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view ZI_CUSTOMPOWIP as select from ZI_POWIP
{
  key ProductionOrder,
  key ProductionOrderItem,
  OrderDate,
  StartDate,
  SalesOrder,
  SalesOrderItem,
  SoldToParty,
  ItemDescription,
  ClusterID,
  BillOfMaterialItemCategory,
  PlanStartDate,
  PlanFinishDate,
  ServiceObjectType,
  OrderScheduledReleaseDate,
  Customer,
  ProductionVersionStatus,
  DeliveryOutboundNumber,
  DeliveryOutboundDate,
  @Semantics.quantity.unitOfMeasure: 'Unit'
  DeliveryOutboundQty,
  Unit,
  GlobalCurrency,
  AccountingDocumentType,
  Ledger,
  _GlobalCurrency,
  _DeliveryQuantityUnit,
   @Semantics.amount.currencyCode: 'GlobalCurrency' 
  MaterialsCost,
   @Semantics.amount.currencyCode: 'GlobalCurrency' 
  ConsumableCost,
   @Semantics.amount.currencyCode: 'GlobalCurrency' 
  SubconCost,
   @Semantics.amount.currencyCode: 'GlobalCurrency' 
  LabourCost,
  
 @Semantics.amount.currencyCode: 'GlobalCurrency' 
  case
    when AccountingDocumentType = 'WA'
    or AccountingDocumentType = 'CO'
    then MaterialsCost + ConsumableCost + SubconCost + LabourCost
    end as TotalWip,
 
 @Semantics.amount.currencyCode: 'GlobalCurrency' 
 case
    when DeliveryOutboundNumber is null
    then MaterialsCost + ConsumableCost + SubconCost + LabourCost
    else 0
end as TotalWIP_WithoutOutbound,
 
  @Semantics.amount.currencyCode: 'GlobalCurrency'  
     case
    when DeliveryOutboundNumber is not null
    then MaterialsCost + ConsumableCost + SubconCost + LabourCost
    else 0
end as Accrued_Cost_of_Sales,
    _ProductionOrderHeader,
    _Customer
}
group by 
  ProductionOrder,
  ProductionOrderItem,
  OrderDate,
  StartDate,
  SalesOrder,
  SalesOrderItem,
  SoldToParty,
  ItemDescription,
  ClusterID,
  PlanStartDate,
  PlanFinishDate,
  DeliveryOutboundNumber,
  DeliveryOutboundDate,
  DeliveryOutboundQty,
  Unit,
  GlobalCurrency,
  Ledger,
  AccountingDocumentType,
  MaterialsCost,
  ConsumableCost,
  SubconCost,
  LabourCost,
  BillOfMaterialItemCategory,
  ServiceObjectType,
  OrderScheduledReleaseDate,
  Customer,
  ProductionVersionStatus
