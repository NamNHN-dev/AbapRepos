@AbapCatalog.sqlViewName: 'ZITEST03'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ProdOrderJE'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_POJE as select from I_JournalEntryItem
{
  key OrderID,
  AccountingDocumentType,
  GlobalCurrency,
  Ledger,
  _GlobalCurrency,
  @Semantics.amount.currencyCode: 'GlobalCurrency'
  sum(AmountInCompanyCodeCurrency) as TotalAmount
}
where OrderID is not null
group by OrderID, AccountingDocumentType, GlobalCurrency,Ledger
