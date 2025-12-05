@AbapCatalog.sqlViewName: 'ZTEXTVIEW05'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Receipt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view ZI_InventoryListing 
  with parameters P_ReportingDate : abap.dats 
  as select from ZI_LatestCreateOnPerMaterial as BASE
  inner join ZI_MDLCreateOn( 
      P_ReportingDate: $parameters.P_ReportingDate 
) as LAST
      on BASE.Material = LAST.Material
      and BASE.StorageLocation = LAST.StorageLocation
      and BASE.CreateOn = LAST.LatestCreateOn
  left outer join I_ProductDescription as IP 
      on  BASE.Material = IP.Product
{
  BASE.Material,
  BASE.StorageLocation,
  BASE.Plant,
  LAST.LatestCreateOn,
  LAST.quantity,
  BASE.PostingDate,
  IP.ProductDescription,
  BASE.Create_On1,
concat(
    concat(
        concat(
            substring(cast(BASE.Create_On1 as abap.char(14)), 5, 2), '/'
        ),
        concat(
            substring(cast(BASE.Create_On1 as abap.char(14)), 7, 2),
            concat('/', substring(cast(BASE.Create_On1 as abap.char(14)), 1, 4))
        )
    ),
    concat(', ',
        concat(
            substring(cast(BASE.Create_On1 as abap.char(14)), 9, 2),
            concat(':',
                concat(
                    substring(cast(BASE.Create_On1 as abap.char(14)), 11, 2),
                    concat(':', substring(cast(BASE.Create_On1 as abap.char(14)), 13, 2))
                )
            )
        )
    )
) as CreatOnFormat,
  BASE._Material,
  BASE._StorageLocation
}
where BASE.Create_On1 <= :P_ReportingDate

