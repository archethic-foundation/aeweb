import 'package:flutter/material.dart';

const kDefaultPadding = 20.0;

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({
    super.key,
    required this.iconSrc,
    required this.title,
    required this.press,
  });

  final String iconSrc, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            const SizedBox(width: kDefaultPadding / 4),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 15, top: 15, right: 5),
                child: Row(
                  children: [
                    const SizedBox(width: kDefaultPadding * 0.75),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(),
                    ),
                    const Spacer(),
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
