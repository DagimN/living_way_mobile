import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
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
    final themeController = Provider.of<ThemeController>(context);

    return AlertDialog(
        title: Text(Tr.t('profile.changeName')),
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
                            if (value == null) {
                              return Tr.t("auth.emptyFieldError");
                            }

                            if (value.trim().isEmpty) {
                              return Tr.t("auth.emptyFieldError");
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: Tr.t("signup.firstNamePlaceholder")))),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                      child: TextFormField(
                          controller: lastNameController,
                          validator: (value) {
                            if (value == null) {
                              return Tr.t("auth.emptyFieldError");
                            }

                            if (value.trim().isEmpty) {
                              return Tr.t("auth.emptyFieldError");
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: Tr.t("signup.lastNamePlaceholder"))))
                ])),
        actions: !isUpdating
            ? [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Tr.t('common.cancel'),
                        style: const TextStyle(color: Colors.red))),
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
                        UIService.pop();
                      });
                    },
                    child: Text(Tr.t('common.update'),
                        style: TextStyle(
                            color: AppTheme(themeController.brightness)
                                .primaryColor)))
              ]
            : [
                Center(
                    child: CircularProgressIndicator(
                        color:
                            AppTheme(themeController.brightness).primaryColor,
                        strokeWidth: 2))
              ]);
  }
}
