import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/report_controller.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/payment.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterDialog extends StatefulWidget {
  final bool showPaidStatus;
  final ReportType reportType;
  final Map<String, String> title;
  const FilterDialog(
      {super.key,
      this.showPaidStatus = false,
      required this.reportType,
      required this.title});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;

  ReportPaymentFilter reportPaymentFilter = ReportPaymentFilter.all;

  Map<ReportPaymentFilter, bool> checkedBoxValue = {
    ReportPaymentFilter.all: true,
    ReportPaymentFilter.paid: false,
    ReportPaymentFilter.notPaid: false,
  };

  ReportController reportController = Get.find<ReportController>();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate = args.value.startDate;
      _endDate = args.value.endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select Date Range',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Select Date Range'),
                          content: SizedBox(
                            width: 500,
                            height: 400.0,
                            child: SfDateRangePicker(
                              enableMultiView: true,
                              onSelectionChanged: _onSelectionChanged,
                              selectionMode: DateRangePickerSelectionMode.range,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  iconSize: 30.0,
                  color: TColors.blue,
                  splashRadius: 25.0,
                  icon: const Icon(Icons.date_range_rounded),
                ),
              ],
            ),
            if (_startDate != null && _endDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${MyFormat.formatDateTwo(_startDate!)} - ${MyFormat.formatDateTwo(_endDate!)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            if (widget.showPaidStatus)
              const Text(
                'Select Paid Status',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 10),
            if (widget.showPaidStatus)
              Wrap(
                  children: ReportPaymentFilter.values
                      .map((filterPaymentType) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: reportPaymentFilter == filterPaymentType,
                                onChanged: (value) {
                                  if (value != null && value) {
                                    reportPaymentFilter = filterPaymentType;
                                  }
                                  setState(() {});
                                },
                              ),
                              Text(filterPaymentType.name()),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ))
                      .toList()),
            SizedBox(
              height: 60.0,
            ),
            Align(
                alignment: Alignment.center,
                child: PosButton(
                    text: 'Generate Report',
                    onPressed: () async {
                      // _startDate = DateTime(2023, 08, 01);
                      // _endDate = DateTime(2023, 09, 30);
                      _startDate = _startDate ?? DateTime(0);
                      _endDate = _endDate ?? DateTime(0);
                      if (_startDate != null || _endDate != null) {
                        DateTimeRange dateTimeRange =
                            DateTimeRange(start: _startDate!, end: _endDate!);
                        await reportController.generateReport(
                            title: widget.title,
                            dateTimeRange: dateTimeRange,
                            reportType: widget.reportType,
                            paidStatus: reportPaymentFilter);
                      }

                      if (!reportController.isrecordAvaliable) {
                        AlertMessage.snakMessage(
                            'No record exsits this time frame', context,
                            duration: 3);
                      }
                      Get.back();
                    }))
          ],
        ),
      ),
    );
  }
}
