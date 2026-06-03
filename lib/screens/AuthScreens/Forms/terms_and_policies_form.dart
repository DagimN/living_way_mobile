import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
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
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(Tr.t("signup.step4Title"),
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
      Text(Tr.t("signup.step4Subtitle"), style: const TextStyle(fontSize: 14)),
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
              onPressed: () async {
                widget.onProgress();
                AnalyticsService.logEvent('signup_step_completed',
                    parameters: {'step': 'terms'});
              },
              child: Text(Tr.t('common.agree'))))
    ]);
  }
}
