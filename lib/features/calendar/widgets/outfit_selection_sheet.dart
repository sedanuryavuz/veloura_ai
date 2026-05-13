import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../outfit/controllers/outfit_controller.dart';
import '../../outfit/models/outfit_model.dart';

class OutfitSelectionSheet {

  static void show({
    required BuildContext context,
    required Function(OutfitModel)
        onSelect,
  }) {

    showModalBottomSheet(

      context: context,

      backgroundColor: Colors.transparent,

      builder: (_) {

        final outfits =
            context.read<OutfitController>()
                .outfits;

        return Container(
          height: 420,

          padding: const EdgeInsets.all(20),

          decoration: const BoxDecoration(
            color: Color(0xffF7F4F5),

            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),

          child: ListView.builder(

            itemCount: outfits.length,

            itemBuilder: (context, index) {

              final outfit = outfits[index];

              return ListTile(

                leading:
                    outfit.top != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                    12),

                            child: Image.file(
                              outfit.top!.imageFile,

                              width: 50,
                              height: 60,

                              fit: BoxFit.cover,
                            ),
                          )
                        : null,

                title:
                    const Text("Saved Outfit"),

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