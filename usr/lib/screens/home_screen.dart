import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/currency_pair.dart';
import 'package:couldai_user_app/models/prediction.dart';
import 'package:couldai_user_app/services/prediction_service.dart';
import 'package:couldai_user_app/widgets/currency_card.dart';
import 'package:couldai_user_app/widgets/prediction_alert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PredictionService _predictionService = PredictionService();
  List<CurrencyPair> _currencyPairs = [];
  Map<String, Prediction?> _predictions = {};
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _initializeCurrencyPairs();
  }

  void _initializeCurrencyPairs() {
    _currencyPairs = [
      CurrencyPair(id: 'EURUSD', name: 'EUR/USD', symbol: '€/\$'),
      CurrencyPair(id: 'GBPUSD', name: 'GBP/USD', symbol: '£/\$'),
      CurrencyPair(id: 'USDJPY', name: 'USD/JPY', symbol: '\$/¥'),
      CurrencyPair(id: 'AUDUSD', name: 'AUD/USD', symbol: 'A\$/\$'),
      CurrencyPair(id: 'USDCAD', name: 'USD/CAD', symbol: '\$/C\$'),
      CurrencyPair(id: 'BTCUSD', name: 'BTC/USD', symbol: '₿/\$'),
      CurrencyPair(id: 'ETHUSD', name: 'ETH/USD', symbol: 'Ξ/\$'),
    ];

    for (var pair in _currencyPairs) {
      _predictions[pair.id] = null;
    }
  }

  void _toggleMonitoring() {
    setState(() {
      _isMonitoring = !_isMonitoring;
    });

    if (_isMonitoring) {
      _startMonitoring();
    } else {
      _stopMonitoring();
    }
  }

  void _startMonitoring() {
    for (var pair in _currencyPairs) {
      _predictionService.startPredicting(pair.id, (prediction) {
        if (mounted) {
          setState(() {
            _predictions[pair.id] = prediction;
          });

          // Mostrar alerta de predicción
          _showPredictionAlert(pair, prediction);
        }
      });
    }
  }

  void _stopMonitoring() {
    _predictionService.stopAllPredictions();
    setState(() {
      for (var key in _predictions.keys) {
        _predictions[key] = null;
      }
    });
  }

  void _showPredictionAlert(CurrencyPair pair, Prediction prediction) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PredictionAlert(
        currencyPair: pair,
        prediction: prediction,
      ),
    );

    // Auto-cerrar después de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _predictionService.stopAllPredictions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.cyanAccent),
            const SizedBox(width: 8),
            const Text(
              'Q-Bot 2.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                _isMonitoring ? 'ACTIVO' : 'INACTIVO',
                style: TextStyle(
                  color: _isMonitoring ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Predicciones con 1 Minuto de Anticipación',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _toggleMonitoring,
                      icon: Icon(_isMonitoring ? Icons.stop : Icons.play_arrow),
                      label: Text(
                        _isMonitoring ? 'Detener Monitoreo' : 'Iniciar Monitoreo',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isMonitoring
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _currencyPairs.length,
              itemBuilder: (context, index) {
                final pair = _currencyPairs[index];
                final prediction = _predictions[pair.id];
                return CurrencyCard(
                  currencyPair: pair,
                  prediction: prediction,
                  isMonitoring: _isMonitoring,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
