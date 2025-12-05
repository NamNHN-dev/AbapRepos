@AbapCatalog.sqlViewName: 'ZINVENTORYMATS01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},
  representativeKey: 'Material',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
@VDM.viewType: #BASIC
define view ZI_InventoryMaterial with parameters P_ReportingDate : abap.dats as select from I_MaterialStock_2 as IM
left outer join ZI_MDLCreateOn (
      P_ReportingDate: $parameters.P_ReportingDate
) as IL
      on IM.Material = IL.Material
      and IM.StorageLocation = IL.StorageLocation
       left outer join I_ProductDescription as IP
      on  IM.Material = IP.Product
{
    key IM.Material,
    key IM.StorageLocation,
    IM.Plant,
    IP.ProductDescription,
    IM.MaterialBaseUnit,
    IL.LatestCreateOn,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default: #SUM
    sum( IM.MatlWrhsStkQtyInMatlBaseUnit ) as quantity,
    max( IM.MatlDocLatestPostgDate ) as LatestPostingDate,
    concat(
    concat(
        concat(
            substring(cast(IL.LatestCreateOn as abap.char(21)), 5, 2), '/'
        ),
        concat(
            substring(cast(IL.LatestCreateOn as abap.char(21)), 7, 2),
            concat('/', substring(cast(IL.LatestCreateOn as abap.char(21)), 1, 4))
        )
    ),
    concat(', ',
        concat(
            substring(cast(IL.LatestCreateOn as abap.char(21)), 9, 2),
            concat(':',
                concat(
                    substring(cast(IL.LatestCreateOn as abap.char(21)), 11, 2),
                    concat(':', substring(cast(IL.LatestCreateOn as abap.char(21)), 13, 2))
                )
            )
        )
    )
) as CreatOnFormat,
    IM._Material,
    IM._StorageLocation,
    IM._Plant
}
where IM.MatlDocLatestPostgDate <= $parameters.P_ReportingDate
group by
    IM.Material,
    IM.Plant,
    IP.ProductDescription,
    IL.LatestCreateOn,
    IM.StorageLocation,
    IM.MaterialBaseUnit
