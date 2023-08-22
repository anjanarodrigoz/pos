import 'package:flutter/material.dart';

import '../theme/t_colors.dart';
import '../utils/my_format.dart';
import '../widgets/paid_status_widget.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({super.key});

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1100,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Invoice #0001'), PaidStatus(isPaid: true)],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detailsRowWidget('Customer ID', '2205'),
                            const SizedBox(
                              height: 5.0,
                            ),
                            detailsRowWidget('Customer Name', 'Anjana Rodrigo'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detailsRowWidget('Created', '25 jul 2023'),
                            const SizedBox(
                              height: 5.0,
                            ),
                            detailsRowWidget('Closed', '33 jul 2024'),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              detailsRowWidget(
                                  'Net Total', MyFormat.formatCurrency(320.00)),
                              const SizedBox(
                                height: 5.0,
                              ),
                              detailsRowWidget(
                                  'GST Total', MyFormat.formatCurrency(32.00)),
                              const SizedBox(
                                height: 5.0,
                              ),
                              detailsRowWidget(
                                  'Total', MyFormat.formatCurrency(352.00)),
                              const SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        )
                      ]),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          invoiceItemView()
        ],
      ),
    );
  }

  Widget detailsRowWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$key : ',
          style: TextStyle(
              color: Colors.grey.shade600, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(color: TColors.blue, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  invoiceItemView() {
    return Expanded(
      child: Scrollbar(
        controller: controller2,
        child: SingleChildScrollView(
          controller: controller2,
          scrollDirection: Axis.horizontal,
          child: Scrollbar(
            controller: controller,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.vertical,
              child: DataTable(
                  dataRowHeight: 17.0,
                  headingRowColor:
                      MaterialStateProperty.all<Color>(Colors.grey.shade300),
                  border: TableBorder(
                    top: BorderSide(),
                    bottom: BorderSide(),
                    left: BorderSide(),
                    right: BorderSide(),
                    verticalInside: BorderSide(),
                  ),
                  columns: const [
                    DataColumn(label: Text('Item Id')),
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Qty')),
                    DataColumn(label: Text('Net Price'), numeric: true),
                    DataColumn(label: Text('GST'), numeric: true),
                    DataColumn(label: Text('Item Price'), numeric: true),
                    DataColumn(label: Text('Total'), numeric: true),
                  ],
                  rows: generateDataRowList(data, comment)),
            ),
          ),
        ),
      ),
    );
  }

  Widget cell(
    String value,
  ) {
    return Container(
      child: Text(
        value,
        style: TStyle.style_01,
      ),
    );
  }

  commentDataRow(String comment) {
    return comment
        .split('\n')
        .map((e) => DataRow(cells: [
              DataCell(
                cell(''),
              ),
              DataCell(SizedBox(
                width: 400.0,
                child: Text(
                  e,
                  style: TStyle.style_02,
                ),
              )),
              DataCell(
                cell(''),
              ),
              DataCell(
                cell(''),
              ),
              DataCell(
                cell(''),
              ),
              DataCell(
                cell(''),
              ),
              DataCell(
                cell(''),
              )
            ]))
        .toList();
  }

  DataRow dataRow(
          {required String id,
          required String name,
          required int qty,
          required double netPrice,
          required double gst,
          required double itemPrice,
          required double total}) =>
      DataRow(cells: [
        DataCell(
          cell('#$id'),
        ),
        DataCell(cell(name)),
        DataCell(cell('$qty')),
        DataCell(cell(MyFormat.formatCurrency(netPrice))),
        DataCell(cell(MyFormat.formatCurrency(gst))),
        DataCell(cell(MyFormat.formatCurrency(itemPrice))),
        DataCell(cell(MyFormat.formatCurrency(total)))
      ]);

  List<DataRow> generateDataRowList(List dataList, String comment) {
    List<DataRow> dataRowList = [];

    for (Map e in dataList) {
      dataRowList.add(dataRow(
        id: e['id'],
        name: e['name'],
        gst: e['gst'].toDouble(),
        netPrice: e['netPrice'].toDouble(),
        itemPrice: e['itemPrice'].toDouble(),
        total: e['total'].toDouble(),
        qty: e['qty'],
      ));

      if (e['comment'] != null) {
        dataRowList += commentDataRow(e['comment']);
      }
      dataRowList += commentDataRow('');
    }

    dataRowList += commentDataRow(comment);

    return dataRowList;
  }

  var comment =
      'Bank Transfer\nbank details :\nAcc no : 8880030445\nbranch : Kaduruwela\nName : M A J Rodrigo';

  var data = [
    {
      "id": "1001",
      "name": "item1",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": "example comment 1"
    },
    {
      "id": "1002",
      "name": "item2",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": null
    },
    {
      "id": "1003",
      "name": "item3",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": "example comment 3\nexample multi comment 3"
    },
    {
      "id": "1004",
      "name": "item4",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": null
    },
    {
      "id": "1005",
      "name": "item5",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": "example comment 5"
    },
    {
      "id": "1006",
      "name": "item6",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": null
    },
    {
      "id": "1007",
      "name": "item7",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": "example comment 7"
    },
    {
      "id": "1008",
      "name": "item8",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": null
    },
    {
      "id": "1009",
      "name": "item9",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": "example comment 9"
    },
    {
      "id": "1010",
      "name": "item10",
      "qty": 30,
      "netPrice": 40,
      "gst": 4,
      "itemPrice": 44,
      "total": 1320,
      "comment": null
    }
  ];
}
