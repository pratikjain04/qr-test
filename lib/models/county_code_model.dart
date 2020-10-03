class CountryCodeModel {
  String countryCode;
  String iAESTEName;
  String countryName;

  CountryCodeModel({this.countryCode, this.iAESTEName, this.countryName});

  CountryCodeModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    iAESTEName = json['IAESTE_Name'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.countryCode;
    data['IAESTE_Name'] = this.iAESTEName;
    data['country_name'] = this.countryName;
    return data;
  }
}
