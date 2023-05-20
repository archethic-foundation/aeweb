/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/util/components/resizable_box.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/util/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PageDetail extends StatelessWidget {
  const PageDetail({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.bottomBar,
  });

  final Widget firstChild;
  final Widget secondChild;
  final Widget bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    'assets/images/background.png',
                  ),
                  fit: Responsive.isMobile(context)
                      ? BoxFit.fitHeight
                      : BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0x00000000),
                  const Color(0x00000000).withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Responsive(
              mobile: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Header(),
                  Expanded(
                    child: firstChild
                        .animate()
                        .fade(duration: const Duration(milliseconds: 200))
                        .scale(duration: const Duration(milliseconds: 200)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: secondChild
                        .animate()
                        .fade(duration: const Duration(milliseconds: 250))
                        .scale(duration: const Duration(milliseconds: 250)),
                  ),
                  bottomBar,
                ],
              ),
              tablet: const SizedBox(),
              desktop: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Header(),
                  Expanded(
                    child: ResizableBox(
                      width: MediaQuery.of(context).size.width - 100,
                      childLeft: firstChild
                          .animate()
                          .fade(duration: const Duration(milliseconds: 200))
                          .scale(duration: const Duration(milliseconds: 200)),
                      childRight: secondChild
                          .animate()
                          .fade(duration: const Duration(milliseconds: 250))
                          .scale(duration: const Duration(milliseconds: 250)),
                    ),
                  ),
                  bottomBar,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
