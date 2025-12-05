@EndUserText.label: 'TF Filtering Production Operations'
@ClientHandling.clientSafe : true
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZTF_PRODOP_FILTER
//with parameters     
//    @Environment.systemField: #CLIENT
  //  p_clnt : abap.clnt
  // test
returns {
  client          : abap.clnt;
  OrderInternalID : abap.numc( 10 );
  OrderOperationInternalID : abap.numc( 8 );
  ProductionOrder : abap.char( 12 );
  ProductionOrderShort : abap.char(12);
  ProductionOrderOperation : abap.char( 4 );
  WorkCenter : abap.char( 8 );
  KeepFlag        : abap.int1;
  Line            : abap.int4;
}
implemented by method ZCL_PRODOP_LOGIC=>GET_FILTERED_OPERATIONS;