/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/util/generic/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteTextFieldName extends ConsumerStatefulWidget {
  const AddWebsiteTextFieldName({
    super.key,
  });

  @override
  ConsumerState<AddWebsiteTextFieldName> createState() =>
      _AddWebsiteTextFieldNameState();
}

class _AddWebsiteTextFieldNameState
    extends ConsumerState<AddWebsiteTextFieldName> {
  late TextEditingController nameController;
  late FocusNode nameFocusNode;

  @override
  void initState() {
    super.initState();
    final addWebsite = ref.read(AddWebsiteFormProvider.addWebsiteForm);
    nameFocusNode = FocusNode();
    nameController = TextEditingController(text: addWebsite.name);
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

    return SizedBox(
      height: 60,
      width: 250,
      child: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          width: 0.5,
                        ),
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
                      ),
                      child: TextField(
                        style: textTheme.labelMedium,
                        autocorrect: false,
                        controller: nameController,
                        onChanged: (text) async {
                          addWebsiteNotifier.setName(
                            text,
                          );
                        },
                        focusNode: nameFocusNode,
                        textAlign: TextAlign.left,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          UpperCaseTextFormatter(),
                          LengthLimitingTextInputFormatter(20),
                        ],
                        decoration: InputDecoration(
                          hintText: "Website's name?",
                          hintStyle: textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.w300),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
