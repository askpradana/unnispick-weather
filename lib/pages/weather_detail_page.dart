import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unnispick/model/responsemodel.dart';

class WeatherDetail extends StatelessWidget {
  const WeatherDetail({
    super.key,
    required this.detailModel,
    required this.cityModel,
    required this.icon,
  });

  final ListElement detailModel;
  final City cityModel;
  final IconData icon;

  String dateInString(DateTime dt) {
    final formattedDate = DateFormat('E, MMM d, y hh:mm a').format(dt);
    return formattedDate;
  }

  oneDigitTemp(double temperature) {
    double temp = temperature - 273.15;
    String formattedTemperature = '${temp.toStringAsFixed(1)} °C';
    return formattedTemperature;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${cityModel.name!}, ${cityModel.country}',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(detailModel.main!.temp! - 273.15).toInt()}°',
                  style: const TextStyle(
                      fontSize: 64, fontWeight: FontWeight.bold),
                ),
                Icon(icon, size: 64),
              ],
            ),
            Text(
              detailModel.weather![0].main!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              detailModel.weather![0].description!,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('temp (min)'),
                    Text(
                      oneDigitTemp(detailModel.main!.tempMin!),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('temp (max)'),
                    Text(
                      oneDigitTemp(detailModel.main!.tempMax!),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            const Text(
              'Data last updated at:',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              dateInString(detailModel.dtTxt!),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
