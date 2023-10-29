import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/welcome/bloc/providers.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_connect_wallet_btn.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_info_version.dart';
import 'package:aeweb/ui/views/welcome/components/welcome_infos.dart';
import 'package:aeweb/ui/views/welcome/header_welcome_screen.dart';
import 'package:busy/busy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  late int selectedPage;
  late final PageController pageController;

  @override
  void initState() {
    selectedPage = 0;
    pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BusyScaffold(
      isBusy: ref.watch(isLoadingWelcomeScreenProvider),
      scaffold: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/background-welcome.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0x00000000),
                    const Color(0xFFCC00FF).withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            _WelcomeScreenResponsiveWidget(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeScreenResponsiveWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return ArchethicScrollbar(
            child: Responsive(
              mobile: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: HeaderWelcomeScreen(),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 60),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: _infosGroup(context),
                    ),
                  ),
                  const WelcomeConnectWalletBtn(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width - 300,
                    ),
                    child: const WelcomeInfoVersion(),
                  ),
                ],
              ),
              tablet: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: HeaderWelcomeScreen(),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 60),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: _infosGroup(context),
                    ),
                  ),
                  const WelcomeConnectWalletBtn(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width - 300,
                    ),
                    child: const WelcomeInfoVersion(),
                  ),
                ],
              ),
              desktop: Container(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: HeaderWelcomeScreen(),
                          ),
                        ],
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 420),
                        padding: const EdgeInsets.only(top: 60),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: _infosGroup(context),
                        ),
                      ),
                      const Spacer(),
                      const WelcomeConnectWalletBtn(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width - 300,
                        ),
                        child: const WelcomeInfoVersion(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _infosGroup(BuildContext context) {
    return [
      WelcomeInfos(
        welcomeArgTitle: AppLocalizations.of(context)!.welcomeArg1Title,
        welcomeArgDesc: AppLocalizations.of(context)!.welcomeArg1Desc,
      ),
      const SizedBox(height: 10),
      WelcomeInfos(
        welcomeArgTitle: AppLocalizations.of(context)!.welcomeArg2Title,
        welcomeArgDesc: AppLocalizations.of(context)!.welcomeArg2Desc,
        animationDuration: 250,
      ),
      const SizedBox(height: 10),
      WelcomeInfos(
        welcomeArgTitle: AppLocalizations.of(context)!.welcomeArg3Title,
        welcomeArgDesc: AppLocalizations.of(context)!.welcomeArg3Desc,
        animationDuration: 300,
      ),
      const SizedBox(height: 10),
      WelcomeInfos(
        welcomeArgTitle: AppLocalizations.of(context)!.welcomeArg4Title,
        welcomeArgDesc: AppLocalizations.of(context)!.welcomeArg4Desc,
        animationDuration: 350,
      ),
    ];
  }
}
