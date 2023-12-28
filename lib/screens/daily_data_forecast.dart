import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class DailyDataForecast extends StatefulWidget {
  final String cityName;
  const DailyDataForecast({
    Key? key,
    required this.cityName,
  }) : super(key: key);

  @override
  State<DailyDataForecast> createState() => _DailyDataForecastState();
}

class _DailyDataForecastState extends State<DailyDataForecast> {
  List<String> getUniqueDays() {
    List<String> uniqueDays = [];
    for (final weather in _weatherDailyData!) {
      print(weather['dt']);

      DateTime time = DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000);
      final day = DateFormat('EEE').format(time);
      if (!uniqueDays.contains(day)) {
        setState(() {
          uniqueDays.add(day);
        });
      }
    }
    return uniqueDays.length <= 7 ? uniqueDays : uniqueDays.sublist(0, 7);
  }

  List<dynamic>? _weatherDailyData;

  Future<void> fetchWeather() async {
    const String apiKey = '';
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=${widget.cityName}&cnt=40&appid=$apiKey'; // Replace with your city name

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          _weatherDailyData = json.decode(response.body)['list'];
        });
        print(_weatherDailyData.toString());
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              "Next Days",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          dailyList(),
        ],
      ),
    );
  }

  Widget dailyList() {
    List<String> uniqueDays = getUniqueDays();
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: uniqueDays.length,
        itemBuilder: (context, index) {
          final weather = _weatherDailyData![index];
          developer.log(weather.toString());
          final DateTime date =
              DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000);
          final double temperature = (weather['main']['temp'] - 273.15);
          final day = uniqueDays[index];
          // print(day.toString());
          return Column(
            children: [
              Container(
                  height: 60,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          day,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 13),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                        width: 30,
                        child: Text("☁️"),
                      ),
                      Text(
                        '${temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  )),
              Container(
                height: 1,
                color: Colors.grey,
              )
            ],
          );
        },
      ),
    );
  }
}
