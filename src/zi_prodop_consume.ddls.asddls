@EndUserText.label: 'Production Order Op Consume'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel:{
  usageType: {
    dataClass: #CUSTOMIZING,
    serviceQuality: #A,
    sizeCategory: #S},  
  representativeKey: 'OrderInternalID',
  dataCategory: #VALUE_HELP,
  modelingPattern: #VALUE_HELP_PROVIDER,
  supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET,
                          #SQL_DATA_SOURCE,
                          #VALUE_HELP_PROVIDER,
                          #CDS_MODELING_DATA_SOURCE ]
}
define view entity ZI_PRODOP_CONSUME as select from ZTF_PRODOP_FILTER
{
    key OrderInternalID,
    key OrderOperationInternalID,
    ProductionOrder,
    ProductionOrderShort,
    ProductionOrderOperation,
    WorkCenter,
    Line
}

