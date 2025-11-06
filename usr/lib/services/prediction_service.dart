import 'dart:async';
import 'dart:math';
import 'package:couldai_user_app/models/prediction.dart';

class PredictionService {
  final Map<String, Timer?> _timers = {};
  final Map<String, double> _lastPrices = {};
  final Random _random = Random();

  // Simula datos de precio base para cada par
  final Map<String, double> _basePrices = {
    'EURUSD': 1.0850,
    'GBPUSD': 1.2650,
    'USDJPY': 148.50,
    'AUDUSD': 0.6520,
    'USDCAD': 1.3580,
    'BTCUSD': 43250.00,
    'ETHUSD': 2280.00,
  };

  void startPredicting(
    String currencyPairId,
    Function(Prediction) onPrediction,
  ) {
    // Inicializar precio si no existe
    _lastPrices[currencyPairId] = _basePrices[currencyPairId] ?? 1.0;

    // Cancelar timer existente si hay uno
    _timers[currencyPairId]?.cancel();

    // Crear nuevo timer que genera predicciones cada 60 segundos
    // (simulando que predice 1 minuto antes)
    _timers[currencyPairId] = Timer.periodic(
      const Duration(seconds: 60),
      (timer) {
        final prediction = _generatePrediction(currencyPairId);
        onPrediction(prediction);
      },
    );

    // Generar predicción inicial inmediatamente
    Future.delayed(const Duration(seconds: 2), () {
      final prediction = _generatePrediction(currencyPairId);
      onPrediction(prediction);
    });
  }

  Prediction _generatePrediction(String currencyPairId) {
    final currentPrice = _lastPrices[currencyPairId] ?? 1.0;
    
    // Generar variación de precio (simulación)
    final basePrice = _basePrices[currencyPairId] ?? 1.0;
    final volatility = basePrice * 0.001; // 0.1% de volatilidad
    
    // Simular tendencia con algo de aleatoriedad
    final trendFactor = (_random.nextDouble() - 0.5) * 2; // -1 a 1
    final priceChange = volatility * trendFactor;
    final newPrice = currentPrice + priceChange;
    
    _lastPrices[currencyPairId] = newPrice;

    // Determinar dirección
    final direction = priceChange > 0 
        ? PredictionDirection.up 
        : PredictionDirection.down;

    // Generar nivel de confianza (70-95%)
    final confidence = 70.0 + (_random.nextDouble() * 25.0);

    return Prediction(
      currencyPairId: currencyPairId,
      direction: direction,
      timestamp: DateTime.now(),
      confidence: confidence,
      currentPrice: currentPrice,
      predictedPrice: newPrice,
    );
  }

  void stopPrediction(String currencyPairId) {
    _timers[currencyPairId]?.cancel();
    _timers.remove(currencyPairId);
  }

  void stopAllPredictions() {
    for (var timer in _timers.values) {
      timer?.cancel();
    }
    _timers.clear();
  }
}
