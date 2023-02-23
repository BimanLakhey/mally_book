import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/configs/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool enableNotifications = false;
  bool darkTheme = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    initiateSharedPreferences();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Settings"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Features",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: Icon(
                Icons.notifications_none_outlined,
                size: 25,
                color: Theme.of(context).splashColor,
              ),
              title: const Text(
                "Notifications",
                style: TextStyle(
                    fontSize: 17
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: Theme.of(context).splashColor,
                value: enableNotifications,
                onChanged: (_) async {
                  enableNotifications = !enableNotifications;
                  await _prefs.setBool("enableNotification", enableNotifications);
                  setState(() {

                  });
                },
              ),
            ),
            const SizedBox(height: 30,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "General",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: Icon(
                Icons.nightlight_outlined,
                size: 25,
                color: Theme.of(context).splashColor,
              ),
              title: const Text(
                "Dark Theme",
                style: TextStyle(
                    fontSize: 17
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: Theme.of(context).splashColor,
                value: darkTheme,
                onChanged: (_) async {
                  darkTheme = !darkTheme;
                  await _prefs.setBool("enableDarkTheme", darkTheme);
                  setState(() {
                    themeSettings.switchTheme();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  initiateSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    enableNotifications = _prefs.getBool("enableNotification") ?? false;
    darkTheme = _prefs.getBool("enableDarkTheme") ?? false;
    setState(() {

    });

  }
}
