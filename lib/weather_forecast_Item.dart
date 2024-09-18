import 'package:flutter/material.dart';

class ForecastItems extends StatelessWidget {
  final String time;
  final String temperature;
  final String iconUrl;
  final String type;

  const ForecastItems({
    super.key,
    required this.time,
    required this.temperature,
    required this.iconUrl,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: type == "Hourly"
                ? [Colors.blueAccent, Colors.lightBlueAccent]
                : [
                    const Color.fromARGB(255, 255, 152, 68),
                    Colors.lightBlueAccent
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Image.network(
              iconUrl,
              height: 36,
              width: 36,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              '$temperature°C',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
