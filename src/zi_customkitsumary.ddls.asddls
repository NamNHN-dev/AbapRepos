@AbapCatalog.sqlViewName: 'ZITESTKIT03'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Monthly Kit Sumary'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  representativeKey: 'SalesOrder',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view ZI_CUSTOMKITSUMARY as select from ZI_ReceivedMonth
{
  key SalesOrder,
  key SalesOrderItem,
  SoldToParty,
  ZZClusterIdSDH,
  ZZReceivedDateSDH,
  ReceivedDateChar,
  CustomerName,
  CustomMonth,
  sum( case when CustomMonth = '01' then 1 else 0 end ) as January,
  sum( case when CustomMonth = '02' then 1 else 0 end ) as February,
  sum( case when CustomMonth = '03' then 1 else 0 end ) as March,
  sum( case when CustomMonth = '04' then 1 else 0 end ) as April,
  sum( case when CustomMonth = '05' then 1 else 0 end ) as May,
  sum( case when CustomMonth = '06' then 1 else 0 end ) as June,
  sum( case when CustomMonth = '07' then 1 else 0 end ) as July,
  sum( case when CustomMonth = '08' then 1 else 0 end ) as August,
  sum( case when CustomMonth = '09' then 1 else 0 end ) as Septemper,
  sum( case when CustomMonth = '10' then 1 else 0 end ) as October,
  sum( case when CustomMonth = '11' then 1 else 0 end ) as November,
  sum( case when CustomMonth = '12' then 1 else 0 end ) as December,
  _SoldToParty
}
group by
  SalesOrder,
  SalesOrderItem,
  SoldToParty,
  ZZClusterIdSDH,
  ZZReceivedDateSDH,
  ReceivedDateChar,
  CustomerName,
  CustomMonth
