@AbapCatalog.sqlViewName: 'ZTEXTVIEW02'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dev (days)'
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
define view ZI_Devdays as select from ZI_PurchaseReceipt as Dev
{
    key Dev.PurchaseOrder,
    key Dev.PurchaseOrderItem,
    Dev.PostingDate,
    Dev.DocumentDate,
    Dev.ScheduleLineDeliveryDate,
    Dev.EffectivePostingDate,
    Dev.MaterialDocument,
    
     @DefaultAggregation: #SUM
    cast(
        dats_days_between(
            cast( Dev.ScheduleLineDeliveryDate as dats ),
            cast( 
                case
                    when Dev.PostingDate is null or Dev.PostingDate = '00000000'
                    then Dev.EffectivePostingDate
                    else Dev.PostingDate
                end
            as dats )
        ) as abap.int4
    ) as DevDays
    
}
