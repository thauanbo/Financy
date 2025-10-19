import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/pages/home/home_page.dart';
import 'package:fabrica_de_software/pages/statistics/statistics_page.dart';
import 'package:fabrica_de_software/pages/clients/clients_page_firestore.dart';
import 'package:fabrica_de_software/pages/workflow/workflow_page.dart';
import 'package:fabrica_de_software/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const StatisticsPage(),
    const ClientsPageWithFirestore(),
    const WorkflowPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  // Navegar para workflow quando estiver na home
                  setState(() {
                    _selectedIndex = 3; // Índice da aba workflow
                  });
                },
                backgroundColor: AppColors.greenlightTwo,
                child: const Icon(Icons.add, color: AppColors.white),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.greenlightTwo,
        unselectedItemColor: AppColors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
