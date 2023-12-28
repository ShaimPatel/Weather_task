// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:weather/screens/city_screen.dart';
import 'package:weather/screens/daily_data_forecast.dart';
import 'package:weather/services/forcast_weather.dart';
import 'package:weather/services/weather.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  WeatherForcast weatherForcast = WeatherForcast();
  late int temperature;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;

  @override
  void initState() {
    super.initState();
    updateUi(widget.locationWeather);
    // weatherForcast.getWeeklyForecast(28.6692, 77.4538);
  }

  //!

  void updateUi(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get Weather data';
        cityName = '';
        return;
      }

      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      weatherMessage = weatherModel.getMessage(temperature);
      cityName = weatherData['name'];
    });
    // print(temperature);
  }

  AssetImage background(String condition) {
    if (weatherIcon == '🌩') {
      return const AssetImage('images/normal_rain.jpg');
    } else if (weatherIcon == '🌧') {
      return const AssetImage('images/rain.jpg');
    } else if (weatherIcon == '☔️') {
      return const AssetImage('images/havy_rain.jpg');
    } else if (weatherIcon == '☃️') {
      return const AssetImage('images/city_backg.jpg');
    } else if (weatherIcon == '🌫') {
      return const AssetImage('images/wind.jpg');
    } else if (weatherIcon == '☀️') {
      return const AssetImage('images/sun.jpg');
    } else if (weatherIcon == '☁️') {
      return const AssetImage('images/cloud.jpg');
    }
    return const AssetImage('images/location_background.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: background(weatherIcon),
            // image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weatherModel.getLocationWeather();
                      updateUi(weatherData);
                    },
                    child: const Icon(
                      Icons.location_on,
                      size: 40.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weatherModel.getCityWeather(typedName);
                        updateUi(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city_rounded,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      weatherIcon,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$weatherMessage in $cityName!',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 20),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: 100,
                  color: Colors.transparent,
                  child: DailyDataForecast(
                    cityName: cityName,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
