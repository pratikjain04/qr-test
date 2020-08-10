class LoginModel {
  String country;
  String pin;

  LoginModel({this.country, this.pin});

  LoginModel.fromJson(Map<String, dynamic> json) {
    country = json['Country'];
    pin = json['Pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Country'] = this.country;
    data['Pin'] = this.pin;
    return data;
  }
}