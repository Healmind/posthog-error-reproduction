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
  String _textValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PostHog Masking Error Reproduction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(80.0.w),
        child: CustomInputText(
          title: 'Text',
          colorCardHome: Colors.white,
          isRequired: true,
          onChanged: (value) {
            setState(() {
              _textValue = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Text is required';
            }
            return null;
          },
        ),
      ),
    );
  }
}
