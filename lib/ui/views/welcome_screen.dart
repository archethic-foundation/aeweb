import 'package:aeweb/header.dart';
import 'package:aeweb/ui/views/website/website_list.dart';
import 'package:aeweb/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SizedBox(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: Responsive(
                mobile: Column(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    Text('Welcome'),
                  ],
                ),
                tablet: Row(
                  children: const [
                    Expanded(
                      flex: 6,
                      child: WebsiteList(),
                    ),
                    Expanded(
                      flex: 9,
                      child: Text('Welcome'),
                    ),
                  ],
                ),
                desktop: Row(
                  children: const [
                    Expanded(
                      flex: 9,
                      child: Text('Welcome'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
