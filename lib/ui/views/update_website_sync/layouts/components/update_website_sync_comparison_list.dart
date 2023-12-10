/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/aeweb_background.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';

class UpdateWebsiteSyncComparisonSheet extends ConsumerStatefulWidget {
  const UpdateWebsiteSyncComparisonSheet({
    super.key,
  });

  @override
  UpdateWebsiteSyncComparisonSheetState createState() =>
      UpdateWebsiteSyncComparisonSheetState();
}

class UpdateWebsiteSyncComparisonSheetState
    extends ConsumerState<UpdateWebsiteSyncComparisonSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  HostingContentComparisonStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final updateWebsiteSyncProvider =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm);

    final filteredFiles = updateWebsiteSyncProvider.comparedFiles
        .where(
          (file) =>
              file.path.toLowerCase().contains(_searchText.toLowerCase()) &&
              (_selectedStatus == null || file.status == _selectedStatus),
        )
        .toList();

    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Stack(
      children: [
        const AEWebBackground(),
        LayoutBuilder(
          builder: (context, constraints) {
            return ArchethicScrollbar(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 5,
                  right: 5,
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100),
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.updateWebSiteDesc,
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Iconsax.warning_2,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              AppLocalizations.of(context)!.disclaimer,
                              style: textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.updateWebSiteDisclaimer,
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .hint_searchFiles,
                            ),
                          ),
                        ),
                        _buildFilterStatusWidget(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${AppLocalizations.of(context)!.lbl_displayedFiles} ${filteredFiles.length}',
                                style: textTheme.bodyMedium,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: filteredFiles.length,
                          itemBuilder: (context, index) {
                            final file = filteredFiles[index];
                            IconData iconData;
                            Color iconColor;
                            String statusText;
                            switch (file.status) {
                              case HostingContentComparisonStatus.localOnly:
                                iconData = Iconsax.document;
                                iconColor = Colors.orange;
                                statusText = AppLocalizations.of(context)!
                                    .status_localOnly;
                                break;
                              case HostingContentComparisonStatus.remoteOnly:
                                iconData = Iconsax.document_cloud;
                                iconColor = Colors.blue;
                                statusText = AppLocalizations.of(context)!
                                    .status_remoteOnly;
                                break;
                              case HostingContentComparisonStatus
                                    .differentContent:
                                iconData = Iconsax.note_remove;
                                iconColor = Colors.red;
                                statusText = AppLocalizations.of(context)!
                                    .status_differentContent;
                                break;
                              case HostingContentComparisonStatus.sameContent:
                                iconData = Iconsax.document_copy;
                                iconColor = Colors.green;
                                statusText = AppLocalizations.of(context)!
                                    .status_sameContent;
                                break;
                            }
                            return Center(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context)
                                          .colorScheme
                                          .background
                                          .withOpacity(1),
                                      Theme.of(context)
                                          .colorScheme
                                          .background
                                          .withOpacity(0.3),
                                    ],
                                    stops: const [0, 1],
                                  ),
                                  border: GradientBoxBorder(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withOpacity(0.5),
                                        Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withOpacity(0.7),
                                      ],
                                      stops: const [0, 1],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: SizedBox(
                                    height: double.infinity,
                                    child: Icon(iconData, color: iconColor),
                                  ),
                                  title: Text(
                                    file.path,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  subtitle: Text(
                                    statusText,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFilterStatusWidget() {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final updateWebsiteSyncProvider =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm);
    final nbOfAll = updateWebsiteSyncProvider.comparedFiles.length;
    final nbOfLocalOnly = updateWebsiteSyncProvider.comparedFiles
        .where(
          (file) => file.status == HostingContentComparisonStatus.localOnly,
        )
        .length;
    final nbOfDifferentContent = updateWebsiteSyncProvider.comparedFiles
        .where(
          (file) =>
              file.status == HostingContentComparisonStatus.differentContent,
        )
        .length;
    final nbOfRemoteOnly = updateWebsiteSyncProvider.comparedFiles
        .where(
          (file) => file.status == HostingContentComparisonStatus.remoteOnly,
        )
        .length;
    final nbOfSameContent = updateWebsiteSyncProvider.comparedFiles
        .where(
          (file) => file.status == HostingContentComparisonStatus.sameContent,
        )
        .length;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = null;
            });
          },
          icon: const Icon(
            Iconsax.filter,
            size: 16,
          ),
          label: Text(
            '${AppLocalizations.of(context)!.status_all} ($nbOfAll)',
            style: textTheme.bodyMedium,
          ),
          style: ButtonStyle(
            backgroundColor: _selectedStatus == null
                ? MaterialStateProperty.all(
                    Colors.blue[100]!.withOpacity(0.2),
                  )
                : null,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = HostingContentComparisonStatus.localOnly;
            });
          },
          icon: const Icon(
            Iconsax.document,
            color: Colors.orange,
            size: 16,
          ),
          label: Text(
            '${AppLocalizations.of(context)!.status_localOnly} ($nbOfLocalOnly)',
            style: textTheme.bodyMedium,
          ),
          style: ButtonStyle(
            backgroundColor:
                _selectedStatus == HostingContentComparisonStatus.localOnly
                    ? MaterialStateProperty.all(
                        Colors.orange[100]!.withOpacity(0.2),
                      )
                    : null,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = HostingContentComparisonStatus.remoteOnly;
            });
          },
          icon: const Icon(
            Iconsax.document_cloud,
            color: Colors.blue,
            size: 16,
          ),
          label: Text(
            '${AppLocalizations.of(context)!.status_remoteOnly} ($nbOfRemoteOnly)',
            style: textTheme.bodyMedium,
          ),
          style: ButtonStyle(
            backgroundColor:
                _selectedStatus == HostingContentComparisonStatus.remoteOnly
                    ? MaterialStateProperty.all(
                        Colors.blue[100]!.withOpacity(0.2),
                      )
                    : null,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = HostingContentComparisonStatus.differentContent;
            });
          },
          icon: const Icon(
            Iconsax.note_remove,
            color: Colors.red,
            size: 16,
          ),
          label: Text(
            '${AppLocalizations.of(context)!.status_differentContent} ($nbOfDifferentContent)',
            style: textTheme.bodyMedium,
          ),
          style: ButtonStyle(
            backgroundColor: _selectedStatus ==
                    HostingContentComparisonStatus.differentContent
                ? MaterialStateProperty.all(Colors.red[100]!.withOpacity(0.2))
                : null,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = HostingContentComparisonStatus.sameContent;
            });
          },
          icon: const Icon(
            Iconsax.document_copy,
            color: Colors.green,
            size: 16,
          ),
          label: Text(
            '${AppLocalizations.of(context)!.status_sameContent} ($nbOfSameContent)',
            style: textTheme.bodyMedium,
          ),
          style: ButtonStyle(
            backgroundColor:
                _selectedStatus == HostingContentComparisonStatus.sameContent
                    ? MaterialStateProperty.all(
                        Colors.green[100]!.withOpacity(0.2),
                      )
                    : null,
          ),
        ),
      ],
    );
  }

  String statusToString(HostingContentComparisonStatus status) {
    switch (status) {
      case HostingContentComparisonStatus.localOnly:
        return AppLocalizations.of(context)!.status_localOnly;
      case HostingContentComparisonStatus.remoteOnly:
        return AppLocalizations.of(context)!.status_remoteOnly;
      case HostingContentComparisonStatus.differentContent:
        return AppLocalizations.of(context)!.status_differentContent;
      case HostingContentComparisonStatus.sameContent:
        return AppLocalizations.of(context)!.status_sameContent;
    }
  }
}
