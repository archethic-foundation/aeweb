/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'add_website_form_sheet.dart';

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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
