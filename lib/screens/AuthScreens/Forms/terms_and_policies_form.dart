import 'package:flutter/material.dart';
import 'package:living_way/constants/urls.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndPoliciesForm extends StatefulWidget {
  final Function() onProgress;
  const TermsAndPoliciesForm({super.key, required this.onProgress});

  @override
  State<TermsAndPoliciesForm> createState() => _TermsAndPoliciesFormState();
}

class _TermsAndPoliciesFormState extends State<TermsAndPoliciesForm> {
  final webViewController = WebViewController()
    ..loadRequest(Uri.parse(Urls.termsUrl));

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    double screenHeight = MediaQuery.sizeOf(context).height;

    //FIXME: On this flow the only permitted device orientation should be portrait

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Almost there",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
      const Text(
          "By reviewing our terms and privacy policy, you can start enjoying our app today.",
          style: TextStyle(fontSize: 14)),
      Container(
          height: screenHeight * .5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: WebViewWidget(controller: webViewController)),
      Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme(themeController.brightness).primaryColor,
                  foregroundColor: Colors.white),
              onPressed: widget.onProgress,
              child: const Text('Agree')))
    ]);
  }
}
