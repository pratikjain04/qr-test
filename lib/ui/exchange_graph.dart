import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:qrtest/utils/constants.dart';


class ExchangeGraph extends StatefulWidget {
  @override
  _ExchangeGraphState createState() => _ExchangeGraphState();
}

class _ExchangeGraphState extends State<ExchangeGraph> {

  List<charts.Series> seriesList;

  // todo: call in initState after dataloading
  static List<charts.Series<ExchangeData, String>> _getCountryData() {
    final random = Random();

    // todo: build this data in initstate
    final data = [
      ExchangeData('Germany', random.nextInt(100)),
      ExchangeData('Austria', random.nextInt(100)),
      ExchangeData('Spain', random.nextInt(100)),
      ExchangeData('Turkey', random.nextInt(100)),
      ExchangeData('USA', random.nextInt(100)),
      ExchangeData('SYRIA', random.nextInt(100)),
      ExchangeData('Iraq', random.nextInt(100)),

    ];

    return [
      charts.Series<ExchangeData, String>(
        id: 'Sales',
        domainFn: (ExchangeData data, _) => data.countryName,
        measureFn: (ExchangeData data, _) => data.offersExchanged,
        data: data,
        displayName: "Your Exchange Data Per Country"
      )
    ];
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      defaultInteractions: true,
    );
  }

  @override
  void initState() {
    super.initState();
    seriesList = _getCountryData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: Constants.height/2.25,
              child: barChart()
            ),
          ),
        ),
      ),
    );
  }
}


// model class for Exchange Data
class ExchangeData {

  final String countryName;
  final int offersExchanged;

  ExchangeData(this.countryName, this.offersExchanged);

}
