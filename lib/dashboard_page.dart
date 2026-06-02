import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_spatial_ride_pooling_system_2/shared/AppColors.dart';

import 'features/home/pages/home_page.dart';
import 'features/home/widgets/side_bar.dart';


class DashboardPage extends StatefulWidget {
  final int initialSelectedIndex;

  const DashboardPage({
    super.key,
    this.initialSelectedIndex = 0,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late int _selectedIndex;
  final List<Widget?> _pages = List.filled(4, null); // Scaled down to exactly 4 items
  DateTime? _lastBackPressed;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
    _pages[_selectedIndex] = _buildPage(_selectedIndex);
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 1:
        return const Scaffold(body: Center(child: Text("Rides Page")));
      case 2:
        return const Scaffold(body: Center(child: Text("Messages Page")));
      case 3:
        return const Scaffold(body: Center(child: Text("Profile Page")));
      default:
        return const SizedBox();
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    HapticFeedback.selectionClick();
    setState(() {
      _selectedIndex = index;
      if (_pages[index] == null) {
        _pages[index] = _buildPage(index);
      }
    });
  }

  void _handlePopInvoked(bool didPop, dynamic result) {
    if (didPop) return;

    final DateTime now = DateTime.now();

    if (_selectedIndex != 0) {
      _onItemTapped(0);
      return;
    }

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      Fluttertoast.showToast(
        msg: "Press again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14,
      );
      return;
    }

    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handlePopInvoked,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: const CustomSidebar(),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages.map((page) => page ?? const SizedBox()).toList(),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.buttonGreen, // Exact green color match from image_9b6182.png
              unselectedItemColor: Colors.grey.shade600,
              elevation: 0,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.directions_car_outlined),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.directions_car),
                  ),
                  label: 'Rides',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.chat_bubble_outline),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.chat_bubble),
                  ),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}