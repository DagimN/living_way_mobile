import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class NameUpdateDialog extends StatefulWidget {
  final String firstName;
  final String lastName;
  const NameUpdateDialog(
      {super.key, required this.firstName, required this.lastName});

  @override
  NameUpdateDialogState createState() => NameUpdateDialogState();
}

class NameUpdateDialogState extends State<NameUpdateDialog> {
  final formKey = GlobalKey<FormState>();
  late final firstNameController =
      TextEditingController(text: widget.firstName);
  late final lastNameController = TextEditingController(text: widget.lastName);
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);

    return AlertDialog(
        title: const Text('Change name'),
        content: Form(
            key: formKey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                      child: TextFormField(
                          controller: firstNameController,
                          validator: (value) {
                            if (value == null) return "Empty Field";

                            if (value.trim().isEmpty) return "Empty Field";

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "First Name"))),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                      child: TextFormField(
                          controller: lastNameController,
                          validator: (value) {
                            if (value == null) return "Empty Field";

                            if (value.trim().isEmpty) return "Empty Field";

                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Last Name")))
                ])),
        actions: !isUpdating
            ? [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () async {
                      final isValid = formKey.currentState?.validate() ?? false;

                      if (!isValid) return;

                      setState(() {
                        isUpdating = true;
                      });

                      final formData = FormData();
                      formData.fields.addAll([
                        MapEntry('id', profileController.userProfile?.id ?? ""),
                        MapEntry('firstName', firstNameController.text),
                        MapEntry('lastName', lastNameController.text)
                      ]);

                      profileController.editProfile(formData).then((value) {
                        setState(() {
                          isUpdating = false;
                        });
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Update',
                        style: TextStyle(color: lightPrimaryColor)))
              ]
            : [
                const Center(
                    child: CircularProgressIndicator(
                        color: lightPrimaryColor, strokeWidth: 2))
              ]);
  }
}
