@AbapCatalog.sqlViewName: 'ZITESTKIT02'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ReceivedMonth'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_ReceivedMonth as select from ZI_KitSumary
{
  key SalesOrder,
  key SalesOrderItem,
  SoldToParty,
  ZZClusterIdSDH,
  ZZReceivedDateSDH,
  ReceivedDateChar,
  CustomerName,
  substring( ReceivedDateChar, 5, 2 ) as CustomMonth,
  _SoldToParty
}
