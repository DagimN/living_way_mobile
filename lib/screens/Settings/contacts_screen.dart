import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:living_way/core/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/models/contacts.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  IconData getLeadingIcon(ContactType type, {String? address}) {
    switch (type) {
      case ContactType.phone:
        return Icons.phone;
      case ContactType.email:
        return Icons.email;
      case ContactType.location:
        return Icons.location_pin;
      case ContactType.social:
        if ((address ?? "").contains('facebook')) {
          return FontAwesomeIcons.facebookF;
        }

        if ((address ?? "").contains('twitter')) {
          return FontAwesomeIcons.twitter;
        }

        if ((address ?? "").contains('youtube')) {
          return FontAwesomeIcons.youtube;
        }

        if ((address ?? "").contains('instagram')) {
          return FontAwesomeIcons.instagram;
        }

        return FontAwesomeIcons.globe;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final contentController = Provider.of<ContentController>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                gradient:
                    AppTheme(themeController.brightness).backgroundGradient),
            child: SafeArea(
                child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back,
                            color: AppTheme(themeController.brightness)
                                .primaryColor)),
                    Text('Contact Us',
                        style: TextStyle(
                            fontSize: 32,
                            color: AppTheme(themeController.brightness)
                                .primaryColor,
                            fontWeight: FontWeight.w300))
                  ])),
              SizedBox(
                  height: orientation == Orientation.portrait
                      ? screenHeight * .84
                      : screenHeight * .73,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    ...contentController.contacts.map((contact) {
                      final addresses = contact.addressList;
                      return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              gradient: AppTheme(themeController.brightness)
                                  .topicGradient,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(contact.title,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme(
                                                    themeController.brightness)
                                                .primaryColor))),
                                ...addresses.map((address) {
                                  return TextButton(
                                      onPressed: () async {
                                        if (contact.type == ContactType.phone) {
                                          launchUrlString("tel://$address");
                                          return;
                                        }

                                        if (contact.type == ContactType.email) {
                                          final emailUri = Uri(
                                              scheme: 'mailto', path: address);
                                          canLaunchUrl(
                                                  emailUri)
                                              .then((canLaunch) => canLaunch
                                                  ? launchUrl(
                                                      emailUri,
                                                      mode: LaunchMode
                                                          .externalApplication)
                                                  : ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              content: Row(
                                                                  children: [
                                                                    Text(
                                                                        'Could not launch email address')
                                                                  ]))));
                                          return;
                                        }

                                        final uri = Uri.tryParse(address);
                                        if (uri != null) {
                                          launchUrl(uri,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Row(children: [
                                                    Text(
                                                        'Could not launch ${contact.type.name} address')
                                                  ])));
                                        }
                                      },
                                      child: Row(children: [
                                        Icon(
                                            getLeadingIcon(contact.type,
                                                address: contact.type ==
                                                        ContactType.social
                                                    ? address
                                                    : null),
                                            color: AppTheme(
                                                    themeController.brightness)
                                                .primaryColor),
                                        const SizedBox(width: 20),
                                        SizedBox(
                                            width: orientation ==
                                                    Orientation.portrait
                                                ? screenWidth * .62
                                                : screenWidth * .75,
                                            child: Text(address,
                                                maxLines: 5,
                                                overflow:
                                                    TextOverflow.ellipsis))
                                      ]));
                                })
                              ]));
                    }),
                    Image.asset(AppImages.logoTransparent)
                  ])))
            ]))));
  }
}
