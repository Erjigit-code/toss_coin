import 'dart:ui';
import 'package:flutter/material.dart';

class CoinSelectionScreen extends StatefulWidget {
  final String initialSelectedCoin;

  CoinSelectionScreen({super.key, required this.initialSelectedCoin});

  @override
  _CoinSelectionScreenState createState() => _CoinSelectionScreenState();
}

class _CoinSelectionScreenState extends State<CoinSelectionScreen> {
  late String selectedCoin;
  late FixedExtentScrollController _controller;
  int selectedIndex = 0;

  final List<Map<String, String>> coins = [
    {
      'id': 'euro',
      'head': 'assets/images/euro_head.png',
      'tail': 'assets/images/euro_tail.png',
      'title': 'Euro'
    },
    {
      'id': 'kg',
      'head': 'assets/images/kg_head.png',
      'tail': 'assets/images/kg_tail.png',
      'title': 'Kyrgyz som'
    },
    {
      'id': 'rus',
      'head': 'assets/images/rus_head.png',
      'tail': 'assets/images/rus_tail.png',
      'title': 'Russian ruble'
    },
    {
      'id': 'us',
      'head': 'assets/images/us_head.png',
      'tail': 'assets/images/us_tail.png',
      'title': 'US dollar'
    },
    // Add more coins as needed
  ];

  List<Map<String, String>> infiniteCoins = [];

  @override
  void initState() {
    super.initState();
    selectedCoin = widget.initialSelectedCoin;
    selectedIndex = coins.indexWhere((coin) => coin['id'] == selectedCoin);

    // Create an infinite list by repeating the coins list
    infiniteCoins = List.generate(1000, (index) => coins[index % coins.length]);

    // Set the initial scroll position to somewhere in the middle
    _controller = FixedExtentScrollController(initialItem: 500);
  }

  void _onConfirmSelection() {
    Navigator.pop(context, selectedCoin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Выбор монеты"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onConfirmSelection,
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background/back.jpeg'), // Путь к вашему изображению
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 16.0),
            child: Center(
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 220,
                perspective: 0.008,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedIndex = index % coins.length;
                    selectedCoin = infiniteCoins[index]['id']!;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    if (index < 0 || index >= infiniteCoins.length) {
                      return null;
                    }
                    final coin = infiniteCoins[index];
                    return _buildImageTile(
                      coin['head']!,
                      coin['tail']!,
                      coin['id']!,
                      coin['title']!,
                    );
                  },
                  childCount: infiniteCoins.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTile(
      String headImagePath, String tailImagePath, String id, String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(45),
        border: selectedCoin == id
            ? Border.all(color: Colors.white, width: 1.2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCoinImage(headImagePath),
              const SizedBox(width: 60),
              _buildCoinImage(tailImagePath),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Exo',
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildCoinImage(String imagePath) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
