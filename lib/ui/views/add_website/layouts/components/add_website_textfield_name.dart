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
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Website's name :",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        TextFormField(
          controller: nameController,
          onChanged: (text) async {
            addWebsiteNotifier.setName(
              text,
            );
          },
        ),
      ],
    );
  }
}
