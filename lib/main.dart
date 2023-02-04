import 'dart:math' as math;

import 'package:babakhani_compass/services/theme_manager.dart';
import 'package:babakhani_compass/utils/compass_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tapsell_plus/tapsell_plus.dart';

void main() {
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));

  const appId =
      "sbdpmdedpgnmlpsgnrojrdqilocjorkalsffqgsgoqiocgqbefrocesapskapbloqcbgld";
  TapsellPlus.instance.initialize(appId);
  TapsellPlus.instance.setGDPRConsent(true);
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasPermissions = false;

  bool _isInit = true;
  @override
  void initState() {
    super.initState();

    _fetchPermissionStatus();
  }

  Future<void> ad() async {
    String adId = await TapsellPlus.instance.requestStandardBannerAd(
        "63cd747ee7c8497f1bd70fed", TapsellPlusBannerType.BANNER_320x50);

    await TapsellPlus.instance.showStandardBannerAd(adId,
        TapsellPlusHorizontalGravity.BOTTOM, TapsellPlusVerticalGravity.CENTER,
        margin: const EdgeInsets.only(bottom: 1), onOpened: (map) {
      // Ad opened
    }, onError: (map) {
      // Error when showing ad
    });
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      if (!_hasPermissions) {
        Permission.locationWhenInUse.request().then((ignored) {
          _fetchPermissionStatus();
        });
      }

      await ad();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.getTheme(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            child: Builder(builder: (context) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<ThemeNotifier>(
                        builder: (context, theme, _) => IconButton(
                          onPressed: () {
                            if (theme.isDarkMode()) {
                              theme.setLightMode();
                            } else {
                              theme.setDarkMode();
                            }
                          },
                          icon: Icon(theme.isDarkMode()
                              ? Icons.light_mode
                              : Icons.dark_mode),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: _hasPermissions
                          ? _buildCompass()
                          : _buildPermissionSheet())
                ],
              );
            }),
          ),
        ),
      );
    });
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading values: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        double? direction = snapshot.data!.heading;
        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors!"),
          );
        }

        double fullDiraction = direction >= 0 ? direction : 360 + direction;

        String accuracy =
            CompassHelper.accuracyToString(snapshot.data!.accuracy!);

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "$accuracy accuracy",
              style: const TextStyle(fontSize: 24),
            ),
            Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 4.0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Transform.rotate(
                  angle: (direction * (math.pi / 180) * -1),
                  child: Consumer<ThemeNotifier>(
                    builder: (context, theme, _) => Image.asset(
                        theme.isDarkMode()
                            ? 'assets/compass_white.png'
                            : 'assets/compass_black.png'),
                  ),
                ),
              ),
            ),
            Text(
              "${fullDiraction.ceil()}° ${CompassHelper.degToCompassDirection(fullDiraction).stringValue}",
              style: const TextStyle(fontSize: 26),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }

  Widget _buildPermissionSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Location Permission Required'),
        ElevatedButton(
          child: const Text('Request Permissions'),
          onPressed: () {
            Permission.locationWhenInUse.request().then((ignored) {
              _fetchPermissionStatus();
            });
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          child: const Text('Open App Settings'),
          onPressed: () {
            openAppSettings().then((opened) {
              //
            });
          },
        )
      ],
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }
}
