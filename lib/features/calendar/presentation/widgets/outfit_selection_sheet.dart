import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../outfit/presentation/provider/outfit_provider.dart';
import '../../../outfit/domain/entities/outfit.dart';

class OutfitSelectionSheet {
  static void show({
    required BuildContext context,
    required Function(Outfit) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final outfits = context.read<OutfitProvider>().outfits;

        return Container(
          height: 420,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xffF7F4F5),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: ListView.builder(
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              final outfit = outfits[index];
              return ListTile(
                leading: outfit.top != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: outfit.top!.imageUrl,
                          width: 50,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      )
                    : null,
                title: Text(outfit.name),
                onTap: () {
                  onSelect(outfit);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}