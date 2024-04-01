import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_api_app/model/weather.dart';

class WeatherService extends ChangeNotifier {
  List<Weather> _weathers = [];
  List<Weather> get weathers => _weathers;
  set weathers(List<Weather> value) {
    _weathers = value;
    notifyListeners();
  }

  void init() async {
    weathers = await getWeatherData();
  }

  Future<List<Weather>> getWeatherData() async {
    String sehir = await _getLocation();
    final String url = 'https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$sehir';

    const Map<String, dynamic> headers = {
      "authorization": "apikey 1U33nmej8rZ9vj9UHQtocM:4MPBMcJFsMrG6GZnrCssZm",
      "content-type": "application/json"
    };

    final dio = Dio();
    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) {
      return Future.error("Bir sorun oluştu");
    }
    final List list = response.data["result"];
    final List<Weather> weatherList = list.map((e) => Weather.fromJson(e)).toList();
    return weatherList;
  }

  Future<String> _getLocation() async {
    // kullanıcının konumu açıkmı kontrol ettik
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error("Konum servisiniz kapalı");
    }

    // kullanıcı konum izni vermiş mi kontrol ettik
    LocationPermission permissions = await Geolocator.checkPermission();
    if (permissions == LocationPermission.denied) {
      // konum izni vermemişse tekrar izin istedik
      permissions = await Geolocator.requestPermission();
      if (permissions == LocationPermission.denied) {
        // yine vermemişse hata döndüürdük
        Future.error("Konum izni vermelisiniz");
      }
    }
    // kullanıcının pozisyonunu aldık
    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // kullanıcı pozisyonundan yerleşim noktasını bulduk
    final List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
    // şehrimizi yerleşim noktasından kaydettik
    final String? sehir = placeMark[0].administrativeArea;

    if (sehir == null) Future.error("Bir sorun oluştu...");

    return sehir!;
  }
}
