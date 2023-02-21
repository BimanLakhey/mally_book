import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mally_book/screens/profile/profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: Divider(),
                ),
                const Text(
                  "Business Settings",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,15,0,30),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(3,3),
                              blurRadius: 10,
                              color: Colors.grey.shade300
                          )
                        ],
                        color: Colors.white
                    ),
                    padding: const EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        customListTile(
                            context: context,
                            leadingIcon: Icons.business,
                            title: "Business Settings",
                            subtitle: "Settings specific to this business",
                            onTap: () {}
                        ),
                      ],
                    ),
                  ),
                ),
                const Text(
                  "General Settings",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,15,0,30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(3,3),
                          blurRadius: 10,
                          color: Colors.grey.shade300
                        )
                      ],
                      color: Colors.white
                    ),
                    padding: const EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        customListTile(
                          context: context,
                          leadingIcon: Icons.app_settings_alt,
                          title: "App Settings",
                          subtitle: "language, Theme, Security, Backup",
                          onTap: () {}
                        ),
                        customListTile(
                            context: context,
                            leadingIcon: CupertinoIcons.person_alt_circle,
                            title: "Your Profile",
                            subtitle: "Name, Mobile Number, Email",
                            onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => ProfilePage()))
                        ),
                        customListTile(
                            context: context,
                            leadingIcon: CupertinoIcons.exclamationmark_circle,
                            title: "About MallyBook",
                            subtitle: "Privacy policy, T&C, About us",
                            onTap: () {}
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => showLogoutDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          offset: const Offset(3,3),
                          color: Colors.grey.shade300
                        )
                      ]
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_outlined,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 20,),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  customListTile({
    required BuildContext context,
    required IconData leadingIcon,
    required String title,
    required String subtitle,
    required onTap
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.pink.shade50
          ),
          child: Icon(
            leadingIcon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),
        ),
        trailing: IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  showLogoutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text("Logout"),
            titleTextStyle: TextStyle(
                color: Theme.of(context).primaryColor
            ),
            content: const Text(
              "Are you sure that you want to logout?",
            ),
            contentTextStyle: TextStyle(
                color: Theme.of(context).primaryColor
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor
                    ),
                  )
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await FirebaseAuth.instance.signOut();
                  },
                  child: const Text(
                    "Yes, logout",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
            ],
          );
        }
    );
  }

}
