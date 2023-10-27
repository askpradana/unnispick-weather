import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unnispick/components/customsnackbar.dart';
import 'package:unnispick/model/responsemodel.dart';
import 'package:unnispick/pages/weather_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherResponseModel model = WeatherResponseModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      final Position position = await _determinePosition();
      final String lon = position.longitude.toString();
      final String lat = position.latitude.toString();
      const String apiKey = '13a3f7263118bf53d84e64942460e28e';

      String baseUrl = "https://api.openweathermap.org/data/2.5/forecast?";
      String link = '$baseUrl&lat=$lat&lon=$lon&appid=$apiKey';

      final response = await http.get(Uri.parse(link));
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['cod'] == "200") {
        setState(() {
          model = WeatherResponseModel.fromJson(responseData);
          isLoading = false;
        });
      }
    } catch (e) {
      CustomSnackbar().customSnackBar(
        content: 'Error fetching weather data: $e',
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  String dateInString(DateTime dt) {
    final formattedDate = DateFormat('E, MMM d, y hh:mm a').format(dt);
    return formattedDate;
  }

  iconDecider(String condition) {
    switch (condition) {
      case "broken clouds":
        return Icons.cloud_circle;
      case "clear sky":
        return Icons.sunny;
      case "few clouds":
        return Icons.cloud_outlined;
      case "overcast clouds":
        return Icons.cloud;
      case "scattered clouds":
        return Icons.cloudy_snowing;
      default:
        return Icons.sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: model.list!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeatherDetail(
                          detailModel: model.list![index],
                          cityModel: model.city!,
                          icon: iconDecider(
                              model.list![index].weather![0].description!),
                        ),
                      ),
                    );
                  },
                  leading: Icon(
                      iconDecider(model.list![index].weather![0].description!)),
                  title: Text(
                    dateInString(model.list![index].dtTxt!),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.list![index].weather![0].main!),
                      Text(
                          'Temp: ${(model.list![index].main!.temp! - 273.15).toInt()} °C')
                    ],
                  ),
                );
              },
            ),
    );
  }
}
