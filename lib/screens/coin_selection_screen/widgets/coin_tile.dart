import 'package:flutter/material.dart';

class CoinTile extends StatelessWidget {
  final String headImagePath;
  final String tailImagePath;
  final String id;
  final String title;
  final bool isSelected;

  const CoinTile({
    Key? key,
    required this.headImagePath,
    required this.tailImagePath,
    required this.id,
    required this.title,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(45),
        border: isSelected ? Border.all(color: Colors.white, width: 1.2) : null,
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
