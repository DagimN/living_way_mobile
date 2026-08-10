import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  static List<Contacts> contacts = [
    Contacts(
        title: 'phoneNumbers',
        addressList: ['+251901777774', '+251901777775'],
        type: ContactType.phone),
    Contacts(
        title: 'emailAddresses',
        addressList: [
          'Info@livingwayethiopia.org',
          'livingwayethiopia@gmail.com'
        ],
        type: ContactType.email),
    Contacts(
        title: 'address',
        addressList: [
          "https://www.google.com/maps/place/ሕያው+መንገድ+ቤ%2Fክ%7C+Living+Way+Church/@9.0086425,38.761634,103m/data=!3m1!1e3!4m6!3m5!1s0x164b8500593bef9b:0xd578173a68457edc!8m2!3d9.008717!4d38.7616153!16s%2Fg%2F11x7kk29zl?entry=ttu&g_ep=EgoyMDI2MDgwNS4xIKXMDSoASAFQAw%3D%3D"
        ],
        type: ContactType.location),
    Contacts(
        title: 'socialMedia',
        addressList: [
          'https://twitter.com/livingwayethiop',
          "https://www.facebook.com/LivingWayChurch1",
          "https://www.instagram.com/livingway_church",
          "https://www.youtube.com/channel/$youtubeChannelId"
        ],
        type: ContactType.social)
  ];

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
          return FontAwesomeIcons.facebookF.data;
        }

        if ((address ?? "").contains('twitter')) {
          return FontAwesomeIcons.twitter.data;
        }

        if ((address ?? "").contains('youtube')) {
          return FontAwesomeIcons.youtube.data;
        }

        if ((address ?? "").contains('instagram')) {
          return FontAwesomeIcons.instagram.data;
        }

        return FontAwesomeIcons.globe.data;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

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
                    Text(Tr.t('contacts'),
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
                    ...contacts.map((contact) {
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
                                    child: Text(Tr.t(contact.title),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme(
                                                    themeController.brightness)
                                                .primaryColor))),
                                ...addresses.map((address) {
                                  return TextButton(
                                      onPressed: () async {
                                        if (contact.type == ContactType.phone) {
                                          AnalyticsService.logEvent(
                                              'phone_number_tapped',
                                              parameters: {'number': address});
                                          launchUrlString("tel://$address");
                                          return;
                                        }

                                        if (contact.type == ContactType.email) {
                                          final emailUri = Uri(
                                              scheme: 'mailto', path: address);
                                          AnalyticsService.logEvent(
                                              'email_address_tapped',
                                              parameters: {'email': address});
                                          canLaunchUrl(emailUri).then(
                                              (canLaunch) => canLaunch
                                                  ? launchUrl(emailUri,
                                                      mode: LaunchMode
                                                          .externalApplication)
                                                  : UIService.showSnackbar(
                                                      backgroundColor: AppTheme(
                                                              themeController
                                                                  .brightness)
                                                          .failedColor,
                                                      message:
                                                          "Could not launch email address"));
                                          return;
                                        }

                                        final uri = Uri.tryParse(address);
                                        if (uri != null) {
                                          AnalyticsService.logEvent(
                                              'contact_link_tapped',
                                              parameters: {'url': address});
                                          launchUrl(uri,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          UIService.showSnackbar(
                                              backgroundColor: AppTheme(
                                                      themeController
                                                          .brightness)
                                                  .failedColor,
                                              message:
                                                  'Could not launch ${contact.type.name} address');
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
