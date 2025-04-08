import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:wheather_app/consts.dart';
import 'package:wheather_app/services/getUserLocation.dart';

class WheatherPage extends StatefulWidget {
  const WheatherPage({super.key});

  @override
  State<WheatherPage> createState() => _WheatherPageState();
}

class _WheatherPageState extends State<WheatherPage> {
  final WeatherFactory _wf = WeatherFactory(OPENWHEATHER_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _wf.currentWeatherByCityName("Gujarat").then((w) {
    //   setState(() {
    //     _weather = w;
    //   });
    // });
    fetchWeatherBasedOnLocation();
  }
  void fetchWeatherBasedOnLocation() async {
    final position = await getUserLocation();
    if (position != null) {
      _wf.currentWeatherByLocation(position.latitude, position.longitude).then((weather) {
        setState(() {
          _weather = weather;
        });
      }).catchError((e) {
        print("Error fetching weather: $e");
      });
    } else {
      print("Could not get location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildUi());
  }


  Widget _buildUi() {
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFFc0effa),
          Color(0xFFe3baf7),
        ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _locationHeader(),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
            _dateTimeInfo(),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
            _weatherIcon(),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            _currentTemp(),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            _extraInfo(),
          ],
        ),
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather!.areaName ?? "",
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(DateFormat("h:mm a").format(now), style: TextStyle(fontSize: 35)),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              "  ${DateFormat("d.m.y").format(now)}",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  _weatherIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
            ),
          ),
        ),
        Text(
          _weather!.weatherDescription ?? "",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather!.temperature!.celsius!.toStringAsFixed(0)}° C",
      style: TextStyle(
        color: Colors.black,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Max: ${_weather!.tempMax!.celsius!.toStringAsFixed(0)}° C",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            "Min: ${_weather!.tempMin!.celsius!.toStringAsFixed(0)}° C",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Wind: ${_weather!.windSpeed!.toStringAsFixed(0)}° C",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            "Humidity: ${_weather!.humidity!.toStringAsFixed(0)}° C",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    ]
      ),
    );
  }
}
