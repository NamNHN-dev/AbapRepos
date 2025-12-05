@AbapCatalog.sqlViewName: 'ZTEXTVIEW03'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Receipt Schedule'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  representativeKey: 'PurchaseOrderItem',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view ZI_PurchaseReceiptSchedule as select from ZI_Devdays as PR
{
    key PR.PurchaseOrder,
    key PR.PurchaseOrderItem,
    PR.PostingDate,
    PR.DocumentDate,
    PR.MaterialDocument,
    PR.EffectivePostingDate,
    PR.ScheduleLineDeliveryDate,
    PR.DevDays, 
    
    @DefaultAggregation: #SUM
    case when PR.DevDays <= 0 then 1 else 0 end as Days_LE_0,
    @DefaultAggregation: #SUM
    case when PR.DevDays between 1 and 3 then 1 else 0 end as Days_1_3,
    @DefaultAggregation: #SUM
    case when PR.DevDays between 4 and 7 then 1 else 0 end as Days_4_7,
    @DefaultAggregation: #SUM
    case when PR.DevDays between 8 and 14 then 1 else 0 end as Days_8_14,
    @DefaultAggregation: #SUM
    case when PR.DevDays between 15 and 21 then 1 else 0 end as Days_15_21,
    @DefaultAggregation: #SUM
    case when PR.DevDays between 22 and 28 then 1 else 0 end as Days_22_28,
    @DefaultAggregation: #SUM
    case when PR.DevDays > 28 then 1 else 0 end as Days_GT_28,
    @DefaultAggregation: #SUM
    case when PR.DevDays is not null then 1 else 0 end as TotalDoc
    
}
