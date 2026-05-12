import 'dart:io';

import 'package:flutter/material.dart';

import '../models/clothing_item_model.dart';

class ClothingCard extends StatelessWidget {
  final ClothingItemModel item;
  final VoidCallback onDelete;

  const ClothingCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.file(
                      File(item.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding:
                          const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(item.category),
              ],
            ),
          ),
        ],
      ),
    );
  }
}