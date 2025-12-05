@AbapCatalog.sqlViewName: 'ZTEXTVIEW08'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CUSTOM LISTING'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  representativeKey: 'MaterialDocument',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view ZI_CUSTOMLISTING with parameters P_ReportingDate : abap.dats as
  select from I_MaterialDocumentItem_2 as MDI 
       association [0..1] to I_MaterialDocumentHeader_2 as MD on $projection.MaterialDocumentYear = MD.MaterialDocumentYear and $projection.MaterialDocument = MD.MaterialDocument 
       association [0..*] to I_ProductDescription as IP on $projection.Material = IP.Product

{ 
         key MaterialDocumentYear,
         key MaterialDocument,
         key MaterialDocumentItem,
         MDI.Material, MDI.MaterialBaseUnit,
         MD.CreationDate,
         MDI.QuantityInBaseUnit,
         @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
         MDI.QuantityInEntryUnit,
         MD.CreationTime,
         MDI.StorageLocation,
         MDI.Plant,
         IP.ProductDescription,

         
         cast(
    dats_tims_to_tstmp(
      MD.CreationDate,
      MD.CreationTime,
      abap_system_timezone($session.client, 'NULL'),
      $session.client,
      'NULL'
    ) as timestamp
  ) as CreateOn,
  _Material,
  _StorageLocation
}     
where MD.CreationDate <= :P_ReportingDate

