enum PredictionDirection {
  up,
  down,
}

class Prediction {
  final String currencyPairId;
  final PredictionDirection direction;
  final DateTime timestamp;
  final double confidence;
  final double currentPrice;
  final double predictedPrice;

  Prediction({
    required this.currencyPairId,
    required this.direction,
    required this.timestamp,
    required this.confidence,
    required this.currentPrice,
    required this.predictedPrice,
  });

  String get directionText => direction == PredictionDirection.up ? 'SUBIR' : 'BAJAR';

  String get emoji => direction == PredictionDirection.up ? '📈' : '📉';
}
