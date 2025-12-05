@AbapCatalog.sqlViewName: 'ZTEXTVIEW01'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Receipt'
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
define view ZI_PurchaseReceipt as select from ZI_POAccr as PR
left outer join I_PurOrdScheduleLineAPI01 as AR on PR.PurchaseOrder = AR.PurchaseOrder 
                                               and PR.PurchaseOrderItem = AR.PurchaseOrderItem
{
    key PR.PurchaseOrder,
    key PR.PurchaseOrderItem,
    PR.DocumentDate,
    PR.PostingDate,
    AR.ScheduleLineDeliveryDate,
    PR.MaterialDocument,
case
    when PR.PostingDate is null
      or PR.PostingDate = ''
      or PR.PostingDate = '00000000'
      or PR.PostingDate = '0000-00-00'
    then cast( $session.system_date as dats )
    else PR.PostingDate
end as EffectivePostingDate

}
