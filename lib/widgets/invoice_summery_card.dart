import 'package:flutter/material.dart';

import '../models/invoice.dart';
import '../theme/t_colors.dart';
import '../utils/my_format.dart';
import 'outstanding_date_widget.dart';
import 'paid_status_widget.dart';

class InvoiceSummeryCard extends StatelessWidget {
  final User invoice;

  const InvoiceSummeryCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (!invoice.isPaid)
                        OutStandingDate(duration: invoice.outStandingDates),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'INVOICE  #${invoice.invoiceId}',
                            style: const TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.bold),
                          ),
                          PaidStatus(isPaid: invoice.isPaid),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 70.0,
                    color: Colors.black,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailsRowWidget('Customer ID  ', invoice.customerId),
                      const SizedBox(
                        height: 5.0,
                      ),
                      detailsRowWidget('Name  ', invoice.customerName),
                      const SizedBox(
                        height: 5.0,
                      ),
                      detailsRowWidget('Mobile  ', invoice.customerMobile),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 70.0,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        detailsRowWidget('Net Total',
                            MyFormat.formatCurrency(invoice.totalNetPrice)),
                        const SizedBox(
                          height: 5.0,
                        ),
                        detailsRowWidget('GST Total',
                            MyFormat.formatCurrency(invoice.totalGstPrice)),
                        const Divider(),
                        detailsRowWidget(
                            'Total', MyFormat.formatCurrency(invoice.total)),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                    height: 70,
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        detailsRowWidget('Paid',
                            MyFormat.formatCurrency(invoice.paidAmount)),
                        const Divider(),
                        detailsRowWidget(
                            'Balance', MyFormat.formatCurrency(invoice.toPay)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  detailsRowWidget(
                      '', MyFormat.formatDate(invoice.createdDate)),
                  const SizedBox(
                    width: 15.0,
                  ),
                  if (invoice.closeDate != null)
                    detailsRowWidget(
                        '', MyFormat.formatDate(invoice.closeDate!)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsRowWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$key ',
          style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
              fontSize: 13.0),
        ),
        Text(
          value,
          style: const TextStyle(
              color: TColors.blue, fontWeight: FontWeight.w600, fontSize: 13.0),
        )
      ],
    );
  }
}
