import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/constants/font_styles.dart';
import 'package:weight_tracker/stores/details_store.dart';
import 'package:weight_tracker/ui/components/manage_weight.dart';

class DetailsSection extends StatefulWidget {
  const DetailsSection({super.key});

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  DetailsStore get _store => context.read<DetailsStore>();

  void _addOrEditWeight() async {
    final picked = await showAdaptiveDialog<double>(
      context: context,
      builder: (context) => const ManageWeightDialogBox(),
    );

    if (picked case double()) {
      _store.addOrEditWeight(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Observer(
            builder: (context) => Text(
              _store.activeDay.value,
              style: context.title,
            ),
          ),
          const SizedBox(height: 16),
          Observer(
            builder: (context) => switch (_store.hasAdded.value) {
              true => Transform.translate(
                  offset: const Offset(20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _store.activeWeight.value.toString(),
                        style: context.h1,
                      ),
                      IconButton(
                        onPressed: _addOrEditWeight,
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              _ => Column(
                  children: [
                    IconButton(
                      onPressed: _addOrEditWeight,
                      icon: const Icon(
                        Icons.add,
                        size: 48,
                      ),
                    ),
                    Text(_store.addHint.value),
                  ],
                ),
            },
          ),
          const SizedBox(height: 16),
          Observer(builder: (context) => Text(_store.summary.value)),
        ],
      ),
    );
  }
}
