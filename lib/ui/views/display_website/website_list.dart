import 'package:aeweb/application/websites.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'website_versions_list.dart';

class WebsiteList extends ConsumerWidget {
  const WebsiteList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final websitesList = ref.watch(WebsitesProviders.fetchWebsites);

    return websitesList.map(
      data: (data) {
        return ArchethicScrollbar(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 30,
              left: 10,
              right: 10,
            ),
            child: ExpansionPanelList.radio(
              children: data.value.map<ExpansionPanel>((Website website) {
                return _contentCard(context, ref, website);
              }).toList(),
            ),
          ),
        );
      },
      error: (error) => const SizedBox(),
      loading: (loading) => const Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: LinearProgressIndicator(
          minHeight: 1,
        ),
      ),
    );
  }
}

ExpansionPanel _contentCard(
  BuildContext context,
  WidgetRef ref,
  Website website,
) {
  return ExpansionPanelRadio(
    headerBuilder: (BuildContext context, bool isExpanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            website.name,
            style: const TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    },
    body: WebsiteVersionsList(
      websiteName: website.name,
      genesisAddress: website.genesisAddress,
    ),
    value: website.genesisAddress,
    canTapOnHeader: true,
  );
}
