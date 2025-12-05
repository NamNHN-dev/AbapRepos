CLASS zcl_prodop_logic DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS GET_FILTERED_OPERATIONS
      FOR TABLE FUNCTION ZTF_PRODOP_FILTER.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_prodop_logic IMPLEMENTATION.
METHOD GET_FILTERED_OPERATIONS BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING ZI_PRODOP_ENTITY.

    lt_raw_data = SELECT sto.mandt as client,
             OrderInternalID,
             OrderOperationInternalID,
             ProductionOrder,
             LTRIM(ProductionOrder, '0') AS ProductionOrderShort,
             ProductionOrderOperation,
             WorkCenter,
             CASE
                WHEN sto.WorkCenter = LAG(sto.WorkCenter, 1) OVER (
                                        PARTITION BY sto.ProductionOrder
                                        ORDER BY sto.ProductionOrderOperation DESC
                                     )
               THEN 0
               ELSE 1
             END AS KeepFlag
      FROM  ZI_PRODOP_ENTITY as sto;

RETURN
      SELECT client,
             OrderInternalID,
             OrderOperationInternalID,
             ProductionOrder,
             ProductionOrderShort,
             ProductionOrderOperation,
             WorkCenter,
             KeepFlag,
             ROW_NUMBER() OVER (
                PARTITION BY ProductionOrder
                ORDER BY ProductionOrderOperation ASC
             ) * 10 AS Line
      FROM :lt_raw_data
      WHERE KeepFlag = 1;

  ENDMETHOD.
ENDCLASS.
