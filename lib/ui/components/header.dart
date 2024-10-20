import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/constants/assets.dart';
import 'package:weight_tracker/constants/colors.dart';
import 'package:weight_tracker/constants/font_styles.dart';
import 'package:weight_tracker/stores/app_store.dart';
import 'package:weight_tracker/stores/details_store.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<AppStore>();
    final detailsStore = context.read<DetailsStore>();
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
                child: Observer(
                  builder: (context) => Text(
                    'hi ${store.name.value}',
                    style: context.title.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Observer(
                  builder: (context) => RichText(
                    text: TextSpan(
                      style: context.paragraph.copyWith(height: 1.8),
                      children: [
                        if (detailsStore.shouldShowSummary.value) ...[
                          TextSpan(
                            text:
                                'you\'ve ${detailsStore.weightDiff.value.name}',
                          ),
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(0, 5),
                              child: Transform.rotate(
                                angle: detailsStore.weightDiff.value.angle,
                                child: LottieBuilder.asset(
                                  Assets.arrow,
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text:
                                '${detailsStore.tenDayDiff.value!.$1.abs()}Kg over the last 10 days with an average weight of ${detailsStore.tenDayDiff.value!.$2}Kg. You ${detailsStore.goalReached.value ? 'have' : 'haven\'t'} reached your goal of ${store.goal.value}Kg',
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => store.setPreferencesPage(),
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
                        ],
                        if (!detailsStore.hasAddedToday.value)
                          const TextSpan(
                            text: 'You haven\'t recorded your weight today.',
                          ),
                      ],
                    ),
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
  const _AnimatedChart();

  @override
  State<_AnimatedChart> createState() => __AnimatedChartState();
}

class __AnimatedChartState extends State<_AnimatedChart>
    with SingleTickerProviderStateMixin {
  DetailsStore get _store => context.read<DetailsStore>();
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
    return Observer(
      builder: (context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Sparkline(
          animationController: _controller,
          fallbackHeight: 150,
          useCubicSmoothing: true,
          data: _store.avlWeights.value,
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
      ),
    );
  }
}
