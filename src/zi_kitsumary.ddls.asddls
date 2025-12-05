@AbapCatalog.sqlViewName: 'ZITESTKIT01'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Kit Sumary'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_KitSumary as select from I_SalesOrderItem as Item
    inner join ZR_SALESDOC_EXTENSION as Header
      on Item.SalesOrder = Header.SalesOrder
{
  @EndUserText.label: 'Sales Order'
  key Item.SalesOrder,
  @EndUserText.label: 'Sales Order Item'
  key Item.SalesOrderItem,
  Item.SoldToParty,
  Item._SoldToParty.CustomerName,
  Header.ZZClusterIdSDH,
  Header.ZZReceivedDateSDH,
  cast( Header.ZZReceivedDateSDH as abap.char(20) ) as ReceivedDateChar,
  Item._SoldToParty
}
