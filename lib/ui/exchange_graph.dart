import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:qrtest/models/county_code_model.dart';
import 'package:qrtest/services/download_excel.dart';
import 'package:qrtest/utils/constants.dart';


class ExchangeGraph extends StatefulWidget {
  @override
  _ExchangeGraphState createState() => _ExchangeGraphState();
}

class _ExchangeGraphState extends State<ExchangeGraph> {

  List<charts.Series> seriesList = []; // for bar graph
  static List<String> outgoingCountries = []; // for outgoingCountryIDs
  List<CountryCodeModel> countryCodeModel = []; // for storing country codes from data.json
  static List<dynamic> dataList = []; // for the dashboard data
  static Map<String, int> graphData = Map<String,int>(); // for creating the final map of data
  /// graphData = {
  ///  "Argentina" : "2",
  ///  "Turkey" : "1"
  /// }

  /// Use this graph to build List of ExchangeData which can be used
  /// in displaying the graph as done in _getCountryData()

  // todo: call in initState after dataloading
  static List<charts.Series<ExchangeData, String>> _getCountryData() {
    final random = Random();

    // todo: build this data in initstate
    var data = [
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

  /// building CountryCodes List from data.json
  /// to access use [countryModel[i].country_code]
 Future<void> buildCountryCodeList() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
    List<dynamic> res = json.decode(data)["code"];

    countryCodeModel?.clear();

    res.forEach((data) {
      countryCodeModel.add(CountryCodeModel.fromJson(data));
    });

  }


 Future<void> calc() async {
    dataList?.clear();
    dataList = DownloadService.offerList.toSet().toList(); // list of scanned data from firebase
    outgoingCountries?.clear();
    /// adding outgoingID to a list for grouping it later
    dataList.forEach((element) {
      outgoingCountries.add(element["Outgoing_ID"].toString().substring(0,2));
    });
    ///sample output for outgoingCountries = ['AR', 'AR', 'TR'];

    outgoingCountries.forEach((id) {
      // todo: count number of offers from each country India has exchanged with
      /// Argentina : 2, Turkey: 1 and display this data on bar graph
      print(id);
      graphData[id] = graphData[id] == null ? 1 : graphData[id] + 1;
    });
    print(graphData); // this graph has all the required information
  }

  @override
  void initState() {
    super.initState();

    buildCountryCodeList().then((value){
      calc();
    });
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
