import 'package:flutter/material.dart';
import 'package:mally_book/screens/books/books_list/books_list_page.dart';
import 'package:mally_book/screens/help/help_page.dart';
import 'package:mally_book/screens/settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget>? _pages;
  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.book_rounded),
      label: "Cashbooks"
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.help_outline_rounded),
        label: "Help"
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: "Settings"
    ),
  ];

  PageController? _pageController;
  int currentIndex = 0;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    _pageController = PageController(initialPage: currentIndex);

    _pages = [
      const BooksListPage(),
      HelpPage(),
      const SettingsPage()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      if(_scaffoldKey.currentState != null) {
        setState(() {});
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages!.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _pages![index];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColor,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex,
        items: _items,
        onTap: (value) {
          currentIndex = value;
          _setPage(currentIndex);
        },
      ),
    );
  }
  void _setPage(int pageIndex) {
    setState(() {
      _pageController?.jumpToPage(pageIndex);
      currentIndex = pageIndex;
    });
  }
}
