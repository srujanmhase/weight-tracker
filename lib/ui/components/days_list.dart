import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/constants/colors.dart';
import 'package:weight_tracker/constants/font_styles.dart';
import 'package:weight_tracker/repositories/extensions.dart';
import 'package:weight_tracker/stores/days_list_store.dart';

class DaysListDisplay extends StatefulWidget {
  const DaysListDisplay({super.key});

  @override
  State<DaysListDisplay> createState() => _DaysListDisplayState();
}

class _DaysListDisplayState extends State<DaysListDisplay>
    with TickerProviderStateMixin {
  DaysListStore get _store => context.read<DaysListStore>();

  late final PageController _controller;
  late final List<AnimationController> _animationControllers;

  late final ReactionDisposer _rxn;

  late final ReactionDisposer _controllerRxn;

  void _triggerAnimations() {
    final prev = _store.previousPage.value.toInt();
    final current = _store.currentPage.value.toInt();

    if (prev != -1) _animationControllers[prev].reverse();
    if (current != -1) _animationControllers[current].forward();
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.12,
    );

    _animationControllers = [];

    _controller.addListener(() {
      _store.setCurrentPage(_controller.page ?? 0);
    });

    _rxn = reaction(
      (_) => _store.currentPage.value,
      (_) => _triggerAnimations(),
      fireImmediately: true,
    );

    _controllerRxn = reaction((_) => _store.days.value.length, (d) {
      _animationControllers.clear();

      _animationControllers.addAll(List.generate(
        _store.days.value.length,
        (i) => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        ),
      ));

      _store.setCurrentPage(0);
      setState(() {});
      _triggerAnimations();
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2), () {
        _triggerAnimations();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationControllers.map((e) => e.dispose());
    _rxn();
    _controllerRxn();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => SizedBox(
        height: 90,
        child: switch (_store.days.value.length) {
          _ when _store.days.value.isNotEmpty => PageView.builder(
              controller: _controller,
              itemCount: _store.days.value.length,
              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                final day = _store.days.value[index].day?.day ?? 0;
                final month = _store.days.value[index].day?.month ?? 0;
                final added = (_store.days.value[index].weight ?? -1) > -1;
                return GestureDetector(
                  onTap: () => _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      day == 1
                          ? Text(
                              month.monthOfYear,
                              style: context.h2,
                            )
                          : const SizedBox(height: 30),
                      _AnimatedDayWidget(
                        key: UniqueKey(),
                        controller: _animationControllers[index],
                        day: day,
                        added: added,
                      ),
                    ],
                  ),
                );
              },
            ),
          _ => const SizedBox(),
        },
      ),
    );
  }
}

class _AnimatedDayWidget extends StatefulWidget {
  const _AnimatedDayWidget({
    super.key,
    required this.controller,
    required this.day,
    required this.added,
  });

  final AnimationController controller;
  final int day;
  final bool added;

  @override
  State<_AnimatedDayWidget> createState() => __AnimatedDayWidgetState();
}

class __AnimatedDayWidgetState extends State<_AnimatedDayWidget> {
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween<double>(begin: 1, end: 1.5).animate(
      widget.controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) => Transform.scale(
        scale: _animation.value,
        child: child,
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.added ? themeGreen : Colors.red,
        ),
        child: Center(
          child: Text(
            widget.day.toString(),
            style: context.xtraLight.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
