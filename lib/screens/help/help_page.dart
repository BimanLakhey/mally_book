import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_whatsapp/open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _platformVersion = 'Unknown';
  final String email = Uri.encodeComponent("biman.lakhey74@gmail.com");

  final String subject = Uri.encodeComponent("Hi, please help me");

  final String body = Uri.encodeComponent("wassup");

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reach The Support Team"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                CupertinoIcons.headphones,
                size: 70,
                color: Theme.of(context).splashColor,
              ),
              const SizedBox(height: 20,),
              const Text(
                "How can we help you?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40,),
              MaterialButton(
                onPressed: () {
                  _launchWhatsapp();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).splashColor,
                      width: 1
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.headphones,
                            size: 30,
                            color: Theme.of(context).splashColor,
                          ),
                          const SizedBox(width: 10,),
                          const Text(
                            "Contact Live Chat",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 22,
                        color: Theme.of(context).splashColor,
                      )

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100,),
              Icon(
                Icons.mail_outline_rounded,
                size: 40,
                color: Theme.of(context).splashColor,
              ),
              const SizedBox(height: 40,),
              const Text(
                "Send us an e-mail",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  sendEmail(context);
                },
                child: const Text(
                  "Biman.lakhey74@gmail.com",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchWhatsapp() async {
    try {
      var whatsapp = "+9779819016941";
      var whatsappAndroid =Uri.parse("https://wa.me/$whatsapp?text=Help me biman");
      await launchUrl(whatsappAndroid, mode: LaunchMode.externalApplication);
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

  }

  sendEmail(BuildContext context) async {
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    try {
      await launchUrl(mail);
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }

  }
}
