import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool appLock = false;
  bool enableNotifications = false;
  bool calculator = false;
  bool darkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Data Security",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: Icon(
                Icons.lock_outline_rounded,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                "App Lock",
                style: TextStyle(
                  fontSize: 17
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: Theme.of(context).primaryColor,
                value: appLock,
                onChanged: (_) {
                  appLock = !appLock;
                  setState(() {

                  });
                },
              ),
            ),
            const SizedBox(height: 30,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Features",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: Icon(
                Icons.notifications_none_outlined,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                "Notifications",
                style: TextStyle(
                    fontSize: 17
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: Theme.of(context).primaryColor,
                value: enableNotifications,
                onChanged: (_) {
                  enableNotifications = !enableNotifications;
                  setState(() {

                  });
                },
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: Icon(
                Icons.calculate_outlined,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                "Amount Field Calculator",
                style: TextStyle(
                    fontSize: 17
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: Theme.of(context).primaryColor,
                value: calculator,
                onChanged: (_) {
                  calculator = !calculator;
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
                    color: Colors.black54,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: Icon(
                Icons.nightlight_outlined,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                "Dark Theme",
                style: TextStyle(
                    fontSize: 17
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: Theme.of(context).primaryColor,
                value: darkTheme,
                onChanged: (_) {
                  darkTheme = !darkTheme;
                  setState(() {

                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
