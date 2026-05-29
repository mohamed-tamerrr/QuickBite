import 'package:flutter/material.dart';

class ToppingCard extends StatelessWidget {
  final String name;
  final String image;

  const ToppingCard({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3A2F2F),
        borderRadius: BorderRadius.circular(16),
      ),
      width: 130,

      margin: const EdgeInsets.only(right: 30),
      child: Column(
        children: [
          // 🔼 Top (Image container)
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.network(image, height: 55),
            ),
          ),

          // 🔽 Bottom (Text + button)
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.add,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
