import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterDialog extends StatefulWidget {
  Map<String, String> title;
  FilterDialog({super.key, required this.title});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  Map<ReportPaymentFilter, bool> checkedBoxValue = {
    ReportPaymentFilter.all: true,
    ReportPaymentFilter.paid: false,
    ReportPaymentFilter.notPaid: false,
    ReportPaymentFilter.halfPaid: false,
  };

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate = args.value.startDate;
      _endDate = args.value.endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: TColors.blue,
        title: Column(
          children: [
            Text(
              widget.title.keys.first,
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              widget.title.values.first,
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
        leading: IconButton(
          iconSize: 20.0,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                            title: Text('Select Date Range'),
                            content: SizedBox(
                              width: 600,
                              child: SfDateRangePicker(
                                enableMultiView: true,
                                onSelectionChanged: _onSelectionChanged,
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
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
              const Text(
                'Select Paid Status',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Wrap(
                  children: checkedBoxValue.entries
                      .toList()
                      .map((filterPaymentType) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: filterPaymentType.value,
                                onChanged: (value) {
                                  checkedBoxValue.forEach((key, value) {
                                    if (key != filterPaymentType.key) {
                                      checkedBoxValue[key] = false;
                                    } else {
                                      checkedBoxValue[key] = true;
                                    }
                                  });
                                  setState(() {});
                                },
                              ),
                              Text(filterPaymentType.key.name()),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ))
                      .toList()),
              SizedBox(
                height: 20.0,
              ),
              Align(
                  alignment: Alignment.center,
                  child: PosButton(text: 'Generate Report', onPressed: () {}))
            ],
          ),
        ),
      ),
    );
  }
}
