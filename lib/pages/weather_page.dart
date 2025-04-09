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
    super.initState();
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return _weather == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF12c2e9), Color(0xFFc471ed)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _locationHeader(),
                      const SizedBox(height: 20),
                      _dateTimeInfo(),
                      const SizedBox(height: 20),
                      _weatherIcon(),
                      const SizedBox(height: 20),
                      _currentTemp(isMobile),
                      const SizedBox(height: 20),
                      _extraInfo(isMobile),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather!.areaName ?? "Your City",
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 26,
        color: Colors.white,
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(fontSize: 36, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(now)}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      children: [
        Image.network(
          "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
          height: 100,
        ),
        Text(
          _weather!.weatherDescription ?? "",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    );
  }

  Widget _currentTemp(bool isMobile) {
    return Text(
      "${_weather!.temperature!.celsius!.toStringAsFixed(0)}° C",
      style: TextStyle(
        color: Colors.white,
        fontSize: isMobile ? 60 : 90,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _extraInfo(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 20,
        runSpacing: 10,
        children: [
          _infoTile("Max", "${_weather!.tempMax!.celsius!.toStringAsFixed(0)}° C"),
          _infoTile("Min", "${_weather!.tempMin!.celsius!.toStringAsFixed(0)}° C"),
          _infoTile("Wind", "${_weather!.windSpeed!.toStringAsFixed(0)} m/s"),
          _infoTile("Humidity", "${_weather!.humidity!.toStringAsFixed(0)}%"),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
