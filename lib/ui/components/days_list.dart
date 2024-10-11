import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/constants/colors.dart';
import 'package:weight_tracker/constants/font_styles.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.12,
    );

    _animationControllers = List.generate(
      _store.days.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _controller.addListener(() {
      _store.setCurrentPage(_controller.page ?? 0);
    });

    _rxn = reaction(
      (_) => _store.currentPage.value,
      (_) {
        final prev = _store.previousPage.value.toInt();
        final current = _store.currentPage.value.toInt();

        _animationControllers[prev].reverse();
        _animationControllers[current].forward();
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationControllers.map((e) => e.dispose());
    _rxn();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: PageView.builder(
        controller: _controller,
        itemCount: 90,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                index % 10 == 0
                    ? Text(
                        'oct',
                        style: context.h2,
                      )
                    : const SizedBox(height: 30),
                _AnimatedDayWidget(
                  controller: _animationControllers[index],
                  index: index,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedDayWidget extends StatefulWidget {
  const _AnimatedDayWidget({required this.controller, required this.index});

  final AnimationController controller;
  final int index;

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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: themeGreen,
        ),
        child: Center(
          child: Text(
            widget.index.toString(),
            style: context.xtraLight.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
