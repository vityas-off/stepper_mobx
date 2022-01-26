import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../stores/steps.dart';

class ColorsStep extends StatelessWidget {
  static const accents = [];

  const ColorsStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ColorSelectStepStore>(context);

    return Observer(
      builder: (_) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: store.colors.length * 33 + 10,
            maxWidth: 300,
          ),
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: store.colors.map(
              (color) {
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: Material(
                    color: color,
                    child: Observer(
                      builder: (_) {
                        return InkWell(
                          onTap: () => store.selectColor(color),
                          child: store.selectedColor == color
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
