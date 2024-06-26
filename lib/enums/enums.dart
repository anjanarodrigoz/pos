enum DrawerName { largeDrawer, smallDrawer }

enum InvoiceItemCategory { item, extraChrage, comment, empty }

enum InvoiceType { invoice, supplyInvoice, quotation, creditNote, returnNote }

enum ReportPaymentFilter { all, paid, notPaid }

enum ReportType {
  invoice,
  creditNote,
  quote,
  summery,
  itemInvoice,
  itemCreditNote,
  itemQuote,
  itemInvoicedItem,
  supplyInvoice,
  supplyItem,
  stockRequired,
  balancedStock,
  customerDetails,
  outstanding,
  stockSellingValue,
  retrunNotes,
  itemReturn,
  supplyTotal,
  supplyItemTotal,
  stockBuyingValue,
  customerPurchase,
  annualReport
}

extension InvoiceTypeCaps on InvoiceType {
  String name() {
    switch (this) {
      case InvoiceType.invoice:
        return ('Tax Invoice');

      case InvoiceType.supplyInvoice:
        return ('Supply Invoice');

      case InvoiceType.quotation:
        return ('Quotation');

      case InvoiceType.creditNote:
        return ('Credit Note');

      case InvoiceType.returnNote:
        return ('Return Note');
      default:
        return 'Invoice';
    }
  }
}

extension Lable on ReportPaymentFilter {
  String name() {
    switch (this) {
      case ReportPaymentFilter.paid:
        return ('Paid');
      case ReportPaymentFilter.all:
        return ('All');

      case ReportPaymentFilter.notPaid:
        return ('Not Paid');

      default:
        return 'Other';
    }
  }
}
