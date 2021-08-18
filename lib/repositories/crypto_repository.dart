import 'dart:convert';
import 'package:crypto_app/models/coin_models.dart';
import 'package:crypto_app/models/failure_model.dart';
import 'package:http/http.dart' as http;

class CryptoRepository {
  static const String _baseUrl = 'https://min-api.cryptocompare.com/';
  static const int perPage = 20;
  static const _apiKey =
      "42748094b301224dc14724eacc4d637d928e1c96dd217e813cd90d8ae4954523";
  final http.Client _httpClient;
  CryptoRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<List<Coin>> getTopCoins({required int? page}) async {
    page = page ?? 1;
    final requestUrl =
        '${_baseUrl}data/top/totalvolfull?limit=$perPage&tsym=USD&page=$page';

    try {
      final response = await _httpClient.get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        final coinList = List.from(data['Data']);
        print(coinList);
        return coinList.map((elem) => Coin.fromMap(elem)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      throw Failure(message: e.toString());
    }
  }
}
