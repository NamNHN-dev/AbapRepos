@AbapCatalog.sqlViewName: 'ZITEXTVIEW07'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material With Lastest Create On'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_MDLCreateOn with parameters P_ReportingDate : abap.dats as
  select from ZI_LatestCreateOnPerMaterial
  
  
{
  key Material,
  key StorageLocation,
  sum(MatlStkChangeQtyInBaseUnit) as quantity,
  max(CreateOn) as LatestCreateOn
}
where CreationDate <= $parameters.P_ReportingDate
group by 
  Material,
  StorageLocation
