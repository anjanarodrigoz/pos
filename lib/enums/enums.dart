enum DrawerName { largeDrawer, smallDrawer }

enum InvoiceItemCategory { item, extraChrage, comment, empty }

enum InvoiceType { invoice, supplyInvoice, quotation, creditNote }

enum ReportPaymentFilter { paid, notPaid, all, halfPaid }

extension InvoiceTypeCaps on InvoiceType {
  String name() {
    switch (this) {
      case InvoiceType.invoice:
        return ('Invoice');

      case InvoiceType.supplyInvoice:
        return ('Supply Invoice');

      case InvoiceType.quotation:
        return ('Quotation');

      case InvoiceType.creditNote:
        return ('Credit Note');
      default:
        return 'Invoice';
    }
  }
}

extension Lable on ReportPaymentFilter {
  String name() {
    switch (this) {
      case ReportPaymentFilter.all:
        return ('All');

      case ReportPaymentFilter.paid:
        return ('Paid');

      case ReportPaymentFilter.notPaid:
        return ('Not Paid');

      case ReportPaymentFilter.halfPaid:
        return ('Half-Paid');
      default:
        return 'Other';
    }
  }
}
