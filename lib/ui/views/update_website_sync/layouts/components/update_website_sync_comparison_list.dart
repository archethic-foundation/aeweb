/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';

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

    return Container(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              Color(0x003C89B9),
              Color(0xFFCC00FF),
            ],
            stops: [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SelectionArea(
                      child: Text(
                        AppLocalizations.of(context)!.updateWebSiteFormTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x003C89B9),
                            Color(0xFFCC00FF),
                          ],
                          stops: [0, 1],
                          begin: AlignmentDirectional.centerEnd,
                          end: AlignmentDirectional.centerStart,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.updateWebSiteDesc,
                style: textTheme.labelMedium,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Icon(
                    Iconsax.warning_2,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!.disclaimer,
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.updateWebSiteDisclaimer,
                style: textTheme.labelMedium,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.hint_searchFiles,
                  ),
                ),
              ),
              _buildFilterStatusWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  '${AppLocalizations.of(context)!.lbl_displayedFiles} ${filteredFiles.length}',
                ),
              ),
              Expanded(
                child: ListView.builder(
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
                        statusText =
                            AppLocalizations.of(context)!.status_localOnly;
                        break;
                      case HostingContentComparisonStatus.remoteOnly:
                        iconData = Iconsax.document_cloud;
                        iconColor = Colors.blue;
                        statusText =
                            AppLocalizations.of(context)!.status_remoteOnly;
                        break;
                      case HostingContentComparisonStatus.differentContent:
                        iconData = Iconsax.note_remove;
                        iconColor = Colors.red;
                        statusText = AppLocalizations.of(context)!
                            .status_differentContent;
                        break;
                      case HostingContentComparisonStatus.sameContent:
                        iconData = Iconsax.document_copy;
                        iconColor = Colors.green;
                        statusText =
                            AppLocalizations.of(context)!.status_sameContent;
                        break;
                    }
                    return Center(
                      child: Card(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.5),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        clipBehavior: Clip.antiAlias,
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
              ),
            ],
          ),
        ),
      ),
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Flexible(
          child: TextButton.icon(
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
              AppLocalizations.of(context)!.status_all,
              style: textTheme.labelMedium,
            ),
            style: ButtonStyle(
              backgroundColor: _selectedStatus == null
                  ? MaterialStateProperty.all(
                      Colors.blue[100]!.withOpacity(0.2),
                    )
                  : null,
            ),
          ),
        ),
        Flexible(
          child: TextButton.icon(
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
              AppLocalizations.of(context)!.status_localOnly,
              style: textTheme.labelMedium,
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
        ),
        Flexible(
          child: TextButton.icon(
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
              AppLocalizations.of(context)!.status_remoteOnly,
              style: textTheme.labelMedium,
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
        ),
        Flexible(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedStatus =
                    HostingContentComparisonStatus.differentContent;
              });
            },
            icon: const Icon(
              Iconsax.note_remove,
              color: Colors.red,
              size: 16,
            ),
            label: Text(
              AppLocalizations.of(context)!.status_differentContent,
              style: textTheme.labelMedium,
            ),
            style: ButtonStyle(
              backgroundColor: _selectedStatus ==
                      HostingContentComparisonStatus.differentContent
                  ? MaterialStateProperty.all(Colors.red[100]!.withOpacity(0.2))
                  : null,
            ),
          ),
        ),
        Flexible(
          child: TextButton.icon(
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
              AppLocalizations.of(context)!.status_sameContent,
              style: textTheme.labelMedium,
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
