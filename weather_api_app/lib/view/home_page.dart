import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_api_app/model/weather.dart';
import 'package:weather_api_app/service/weather_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context, listen: false);
    weatherService.init(); // init() metodunu çağır
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<WeatherService>(
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.weathers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(color: Colors.blueGrey.shade100, borderRadius: BorderRadius.circular(15)),
                child: _buildFirstColumn(value.weathers[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFirstColumn(Weather weather) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          weather.gun,
          style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          child: _buildSecondColumn(weather),
        ),
      ],
    );
  }

  Widget _buildSecondColumn(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          weather.ikon,
          width: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weather.durum.toUpperCase(),
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${weather.derece} °",
                style: const TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Diğer bilgileri buraya ekleyebilirsiniz
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBilgiColumn("Min: ${weather.min} °", "Max : ${weather.max} °"),
            _buildBilgiColumn("Gece: ${weather.gece} °", "Nem: ${weather.nem}"),
          ],
        )
      ],
    );
  }

  Widget _buildBilgiColumn(String deger1, String deger2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          deger1,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          deger2,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
