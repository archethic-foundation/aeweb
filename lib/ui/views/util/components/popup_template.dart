import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/util/components/popup_close_button.dart';
import 'package:flutter/material.dart';

class PopupTemplate extends StatelessWidget {
  const PopupTemplate({
    super.key,
    required this.popupContent,
    required this.popupTitle,
    required this.popupHeight,
    this.warningCloseLabel = '',
    this.warningCloseFunction,
  });

  final Widget popupContent;
  final String popupTitle;
  final double popupHeight;
  final String warningCloseLabel;
  final Function? warningCloseFunction;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent.withAlpha(120),
            body: AlertDialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Stack(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 30, right: 15, left: 8),
                    padding: const EdgeInsets.all(20),
                    height: popupHeight,
                    width: AeWebThemeBase.sizeBoxComponentWidth,
                    decoration: BoxDecoration(
                      color: AeWebThemeBase.backgroundPopupColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: popupContent,
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: SelectionArea(
                              child: Text(
                                popupTitle,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 50,
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: AeWebThemeBase.gradient,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: PopupCloseButton(
                      warningCloseLabel: warningCloseLabel,
                      warningCloseFunction: warningCloseFunction,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
