import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weight_tracker/constants/assets.dart';
import 'package:weight_tracker/constants/colors.dart';
import 'package:weight_tracker/constants/font_styles.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: themeGrey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'hi Srujan',
                  style: context.title.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: RichText(
                  text: TextSpan(
                    style: context.paragraph.copyWith(height: 1.8),
                    children: [
                      const TextSpan(text: 'you\'ve lost'),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(0, 5),
                          child: LottieBuilder.asset(
                            Assets.arrow,
                            height: 40,
                          ),
                        ),
                      ),
                      const TextSpan(
                          text:
                              '30gm over the last 10 days with an average weight of 62.1Kg. You haven\'t reached your goal of 65Kg'),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => print('ok'),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(
                        text: 'You haven\'t recorded your weight today.',
                      ),
                    ],
                  ),
                ),
              ),
              const _AnimatedChart(),
            ],
          ),
        ),
        Container(
          height: 64,
          color: themeGrey,
          child: Container(
            height: 64,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedChart extends StatefulWidget {
  const _AnimatedChart({super.key});

  @override
  State<_AnimatedChart> createState() => __AnimatedChartState();
}

class __AnimatedChartState extends State<_AnimatedChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Sparkline(
        animationController: _controller,
        fallbackHeight: 150,
        data: const [100, 200, 156, 286, 220, 244, 180],
        fillMode: FillMode.below,
        lineColor: Colors.white,
        fillGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.3),
            themeGrey,
          ],
        ),
      ),
    );
  }
}
