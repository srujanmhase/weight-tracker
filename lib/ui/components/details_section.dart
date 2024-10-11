import 'package:flutter/material.dart';
import 'package:weight_tracker/constants/font_styles.dart';

class DetailsSection extends StatefulWidget {
  const DetailsSection({super.key});

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Text(
            'Today',
            style: context.title,
          ),
          const SizedBox(height: 16),
          Transform.translate(
            offset: const Offset(20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '62.4',
                  style: context.h1,
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('40gm lower than yesterday'),
        ],
      ),
    );
  }
}
