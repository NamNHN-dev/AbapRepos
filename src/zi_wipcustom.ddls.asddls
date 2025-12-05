@AbapCatalog.sqlViewName: 'ZITEST01'
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
define view ZI_POWIP
  as select from I_ProductionOrderItem as prod
    left outer join I_SalesOrderItem as soitem 
      on prod.SalesOrder = soitem.SalesOrder
     and prod.SalesOrderItem = soitem.SalesOrderItem
    left outer join I_OutboundDeliveryItem as deliitem
      on soitem.SalesOrder = deliitem.ReferenceSDDocument
     and soitem.SalesOrderItem = deliitem.ReferenceSDDocumentItem
    left outer join I_OutboundDelivery as delihdr
      on deliitem.OutboundDelivery = delihdr.OutboundDelivery
    left outer join ZR_SALESDOC_EXTENSION as ext
      on soitem.SalesOrder = ext.SalesDocument
    left outer join I_ProductionOrderComponent as comp
      on prod.ProductionOrder = comp.ProductionOrder
left outer join ZI_POJE as je
  on prod.ProductionOrder = je.OrderID
{
  key prod.ProductionOrder,
  key prod.ProductionOrderItem,
  prod._ProductionOrderHeader.CreationDate  as OrderDate,
  prod._ProductionOrderHeader.OrderScheduledStartDate as StartDate,
  prod.SalesOrder,
  prod.SalesOrderItem,
  soitem.SoldToParty,
  soitem.SalesOrderItemText as ItemDescription,
  ext.ZZClusterIdSDH as ClusterID,
  ext.ZZPlanStartDateSDH as PlanStartDate,
  ext.ZZPlanFinishDateSDH as PlanFinishDate,
  deliitem.OutboundDelivery as DeliveryOutboundNumber,
  delihdr.DeliveryDate as DeliveryOutboundDate,
  @Semantics.quantity.unitOfMeasure: 'Unit'
  deliitem.ActualDeliveryQuantity as DeliveryOutboundQty,
  deliitem.DeliveryQuantityUnit as Unit,
  comp.BillOfMaterialItemCategory,
  je.GlobalCurrency,
  je.AccountingDocumentType,
  je._GlobalCurrency,
  je.Ledger,
  deliitem._DeliveryQuantityUnit, 
  prod._CoProductReservationItem.ServiceObjectType,
  prod._ProductionOrderHeader.OrderScheduledReleaseDate,
  prod._CoProductReservation.Customer,
  prod._ProductionVersion.ProductionVersionStatus,

  @Semantics.amount.currencyCode: 'GlobalCurrency'
 sum( case when  je.AccountingDocumentType = 'WA'
            and  comp.BillOfMaterialItemCategory = 'L' 
            then je.TotalAmount else 0 end ) as MaterialsCost,
            
  @Semantics.amount.currencyCode: 'GlobalCurrency'          
  sum( case when  comp.BillOfMaterialItemCategory = 'N'
            and not ( comp.Material like 'A70%' )
            and je.AccountingDocumentType = 'WA'
            then je.TotalAmount else 0 end ) as ConsumableCost,
            
  @Semantics.amount.currencyCode: 'GlobalCurrency'             
  sum( case when  comp.BillOfMaterialItemCategory = 'N'
            and ( comp.Material like 'A70%' )
            and je.AccountingDocumentType = 'WA'
            then je.TotalAmount else 0 end ) as SubconCost,
            
  @Semantics.amount.currencyCode: 'GlobalCurrency'            
  sum( case when je.AccountingDocumentType = 'CO'
            then je.TotalAmount else 0 end ) as LabourCost,
            
    prod._ProductionOrderHeader,
    prod._CoProductReservation._Customer
}
group by
  prod.ProductionOrder,
  prod.ProductionOrderItem,
  prod._ProductionOrderHeader.CreationDate,
  prod._ProductionOrderHeader.OrderScheduledStartDate,
  prod.SalesOrder,
  prod.SalesOrderItem,
  soitem.SoldToParty,
  soitem.SalesOrderItemText,
  ext.ZZClusterIdSDH,
  ext.ZZPlanStartDateSDH,
  ext.ZZPlanFinishDateSDH,
  deliitem.OutboundDelivery, 
  delihdr.DeliveryDate,
  deliitem.ActualDeliveryQuantity,
  deliitem.BaseUnit,
  je.GlobalCurrency,
  deliitem.DeliveryQuantityUnit,
  je.AccountingDocumentType,
  je.Ledger,
  comp.BillOfMaterialItemCategory,
  prod._CoProductReservationItem.ServiceObjectType,
  prod._ProductionOrderHeader.OrderScheduledReleaseDate,
  prod._CoProductReservation.Customer,
  prod._ProductionVersion.ProductionVersionStatus
