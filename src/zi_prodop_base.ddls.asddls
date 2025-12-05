@AbapCatalog.sqlViewName: 'ZVPRODOPBASE'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Operation Base'
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
@VDM.viewType: #BASIC
define view ZI_PRODOP_BASE as select from I_ProductionOrderOperation_2 as op
{   
    key op.OrderInternalID,
    key op.OrderOperationInternalID,
    op.ProductionOrder,
    op.ProductionOrderOperation,
    op.ProductionOrderOperationText,
    op.WorkCenterType,
    op.WorkCenterInternalID,
    op._WorkCenter.WorkCenter as WorkCenter,
    op._WorkCenter
}
group by
    op.OrderInternalID,
    op.OrderOperationInternalID,
    op.ProductionOrder,
    op.ProductionOrderOperation,
    op.ProductionOrderOperationText,
    op._WorkCenter.WorkCenter,
    op.WorkCenterType,
    op.WorkCenterInternalID

