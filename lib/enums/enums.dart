enum DrawerName { largeDrawer, smallDrawer }

enum InvoiceItemCategory { item, extraChrage, comment, empty }

enum InvoiceType { invoice, supplyInvoice, quotation, creditNote }

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
