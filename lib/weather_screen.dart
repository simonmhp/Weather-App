import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additiona_info_item.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weather_forecast_Item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = 'VIKASNAGAR';
  List<String> cities = ['VIKASNAGAR', 'DEHRADUN', 'HERBERTPUR'];

  Future<Map<String, dynamic>> getCurrentWeather() async {
    final ctyname = cityName == "VIKASNAGAR"
        ? "vikasnagar"
        : cityName == "DEHERADUN"
            ? "Dehradun"
            : "herbertpur";
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$weatherAPIKey&q=$ctyname&days=7&aqi=no&alerts=no',
        ),
      );

      // Decode the JSON response
      final data = jsonDecode(response.body);

      // Check if there's an error in the response
      if (response.statusCode != 200) {
        throw 'An Expected Error Occurred: ${data['error']['message']}';
      }

      return data;
    } catch (e) {
      throw 'Error fetching weather data: $e';
    }
  }

  double convertToCelsius(double kelvin) {
    return double.parse((kelvin - 273.15).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // Refresh the weather data when the refresh button is pressed
                getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;
          final currentWData = data['current'];
          final day0Forcast = data['forecast']['forecastday'][0];
          final day1Forcast = data['forecast']['forecastday'][1];

          final currentTemp = currentWData['temp_c'];
          final currentSky = currentWData['condition']['text'];
          final currentPressure = currentWData['pressure_mb'];
          final currentWindSpeed = currentWData['wind_kph'];
          final currentHumidity = currentWData['humidity'];
          final currentTempMin = day0Forcast['day']['mintemp_c'];
          final currentTempMax = day0Forcast['day']['maxtemp_c'];
          final iconUrl = currentWData['condition']['icon'];

          // final time1 = DateTime.parse(day1Forcast['hour'][1]['time']);

          // final formattedDate1 = DateFormat('MMM d').format(time1);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DropdownButton<String>(
                                  value: cityName,
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color:
                                        const Color.fromARGB(255, 247, 242, 92),
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      cityName = newValue!;
                                      getCurrentWeather();
                                    });
                                  },
                                  items: cities.map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "$currentTemp °C",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Icon(
                                //   currentSky == 'Sunny'
                                //       ? Icons
                                //           .wb_sunny // Use a suitable rain icon
                                //       : currentSky == 'Partly Cloudy '
                                //           ? Icons.cloud
                                //           : Icons.grain,
                                //   size: 36,
                                //   color: Colors.white,
                                // ),
                                Image.network(
                                  'https:$iconUrl', // Use Image.network to display the icon from URL
                                  height: 36,
                                  width: 36,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Min: $currentTempMin °C",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                    Text(
                                      "Max: $currentTempMax °C",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // WeatherForecast Card
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hourly Forecast",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 151,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          min((day0Forcast['hour'].length / 3).ceil(), 10),
                      itemBuilder: (context, index) {
                        // Calculate the actual index for the item based on the interval
                        final actualIndex = index * 3;

                        // Ensure the index does not exceed the available data length
                        if (actualIndex >= day0Forcast['hour'].length) {
                          return const SizedBox
                              .shrink(); // Or some other placeholder widget
                        }

                        final hourlyForecast = day0Forcast['hour'][actualIndex];
                        final iconUrl = hourlyForecast['condition']
                            ['icon']; // Get the icon URL
                        final time = DateTime.parse(hourlyForecast['time']);

                        return ForecastItems(
                          time: DateFormat.j().format(time),
                          temperature: hourlyForecast['temp_c'].toString(),
                          iconUrl: 'https:$iconUrl',
                          type: 'Hourly', // Construct full URL for the icon
                        );
                      },
                    ),
                  ),

                  //Daily Forecast

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Daily Forecast",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 151,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final dayForcast =
                            data['forecast']['forecastday'][index + 1];
                        final date = DateTime.parse(
                            dayForcast['hour'][index + 1]['time']);
                        final icnUrl = dayForcast['day']['condition']['icon'];
                        final maxTemp = day1Forcast['day']['maxtemp_c'];
                        final formattedDate = DateFormat('MMM d').format(date);
                        return ForecastItems(
                          time: formattedDate,
                          temperature: maxTemp.toString(),
                          iconUrl: 'https:$icnUrl',
                          type: 'Daily', // Construct full URL for the icon
                        );
                      },
                    ),
                  ),
                  //-------------------------------------------------------------------------------------------------------------------------------------------------
                  const SizedBox(height: 20),
                  // Additional Information
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInforItem(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInforItem(
                        icon: Icons.air,
                        label: "Wind Speed",
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInforItem(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
