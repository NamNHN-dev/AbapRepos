@AbapCatalog.sqlViewName: 'ZITEXTVIEW06'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest Create On'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_LatestCreateOnPerMaterial as
  select from I_MaterialDocumentItem_2 as MDI
    inner join I_MaterialDocumentHeader_2 as MD
      on  MDI.MaterialDocumentYear = MD.MaterialDocumentYear
      and MDI.MaterialDocument     = MD.MaterialDocument
      inner join I_GoodsMovementCube  as GM
    on  GM.MaterialDocumentYear = MDI.MaterialDocumentYear
    and GM.MaterialDocument = MDI.MaterialDocument
    and GM.MaterialDocumentItem = MDI.MaterialDocumentItem
{ 
  key MDI.MaterialDocumentYear,
  key MDI.MaterialDocument,
  key MDI.MaterialDocumentItem,
  MDI.SalesOrder,
  MDI.SalesOrderItem,
  MDI.Material,
  MDI.MaterialBaseUnit,
  MDI.PostingDate,
  MDI.QuantityInBaseUnit,
  MD.StorageLocation,
  MD.Plant,
  MD.CreationDate,
  MD.CreationDate as CreateOnDate,
  MD.CreationTime,
GM.MatlStkChangeQtyInBaseUnit,
  
 @Search: {
                    defaultSearchElement: true,
                    fuzzinessThreshold: 0.9,
                    ranking: #MEDIUM
                }
      @Semantics.businessDate.at: true
cast( concat( MD.CreationDate, MD.CreationTime ) as abap.char(21) ) as CreateOn,
  concat(MD.CreationDate,MD.CreationTime) as Create_On1,
  MDI._Material,
  MD._StorageLocation
}
