import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/widgets/title_text_button.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/* --------------------------------------------------------------------------

Widget Title: Menu Drawer
Widget Description: Widget for menu drawer that pops out from the side, this
includes the animation controller for its staggered animation outwards. 

-----------------------------------------------------------------------------*/

class Menu extends StatefulWidget {
  final AnimationController dsController;

  Menu({required this.dsController});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _extraTime = Duration(milliseconds: 300);

  final _animationDuration =
      _initialDelayTime + (_staggerTime * kMenuTitles.length) + _extraTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < kMenuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }
  }

  bool isDrawerOpen() {
    return widget.dsController.value == 1.0;
  }

  bool isDrawerOpening() {
    return widget.dsController.status == AnimationStatus.forward;
  }

  void toggleDrawer() {
    if (isDrawerOpen() || isDrawerOpening()) {
      widget.dsController.reverse();
    } else {
      widget.dsController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900.withOpacity(0.3),
      child: BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        ..._buildListItems(),
        const Spacer(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < kMenuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: TitleTextButton(
              buttonText: kMenuTitles[i][0],
              pressedFunction: () {
                Navigator.pushReplacementNamed(context, kMenuTitles[i][1]);
                toggleDrawer();
              },
            ),
          ),
        ),
      );
    }
    return listItems;
  }
}
