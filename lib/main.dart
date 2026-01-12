import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'custom_input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config =
  PostHogConfig('phc_WfjklKKDvnrWljNwlLIyxBgV46fpOiHiDb3L76FMSW9');
  config.debug = true;
  config.captureApplicationLifecycleEvents = true;
  config.host = 'https://eu.i.posthog.com';
  config.sessionReplay = true;
  config.sessionReplayConfig.maskAllTexts = true;
  config.sessionReplayConfig.maskAllImages = false;
  config.sessionReplayConfig.throttleDelay =
  const Duration(milliseconds: 300);
  await Posthog().setup(config);
  print('PostHog initialized');

  await Posthog().capture(
      eventName: 'test_event_error_capture',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PostHogWidget(
        child: ScreenUtilInit(
          designSize: const Size(360, 800),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
              ),
              home: const PostHogErrorReproduction(),
            );
          },
        ));
  }
}

class PostHogErrorReproduction extends StatefulWidget {
  const PostHogErrorReproduction({super.key});

  @override
  State<PostHogErrorReproduction> createState() => _PostHogErrorReproductionState();
}

class _PostHogErrorReproductionState extends State<PostHogErrorReproduction> {
  String _email = '';

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomInputText(
                  title: 'Email',
                  colorCardHome: Colors.grey[100]!,
                  controllerText: _email,
                  fieldKey: 'resend_activation_email',
                  validator: _usernameValidator,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  iconCardLogin: null,
                  isRequired: false,
                  readOnly: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
