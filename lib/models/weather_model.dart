class WheatherModel{

  final String cityName;
  final String temprature;
  final String mainCondition;

  WheatherModel({required this.cityName, required this.temprature,required this.mainCondition });

  factory WheatherModel.fromJson(Map<String, dynamic> json){
    return WheatherModel(cityName: json['name'], temprature: json['main']['temp'].toDouble(), mainCondition: json['weather']['0']['main']);
  }

}