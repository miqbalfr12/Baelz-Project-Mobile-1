import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:uas/bloc/bottom_nav_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:uas/pages/add/AddProduct.dart';
import 'package:uas/pages/add/AddSales.dart';
import 'package:uas/pages/add/AddStock.dart';

import '../pages/pages.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// Top Level Pages
  final List<Widget> topLevelPages = const [
    HomePage(),
    ProductPage(),
    NotificationsPage(),
    SalesPage(),
  ];

  /// on Page Changed
  void onPageChanged(int page) {
    BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Could not launch. Please check your internet connection.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          alignment: Alignment.bottomCenter,
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.amber,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Baelz Project",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    "Mobile Developer",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(.1)),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat,
                        size: 28,
                        color: Colors.black,
                      ),
                      onPressed: () => setState(() {
                        _launchInBrowser(Uri(
                            scheme: 'https',
                            host: 'wa.me',
                            path: '62895396161325/'));
                      }),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(.1)),
                    child: IconButton(
                      icon: const Icon(
                        Icons.code,
                        size: 28,
                        color: Colors.black,
                      ),
                      onPressed: () => setState(() {
                        _launchInBrowser(Uri(
                            scheme: 'https',
                            host: 'github.com',
                            path: 'miqbalfr12/Baelz-Project-Mobile-1'));
                      }),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: _mainWrapperBody(),
        )
      ]),
      bottomNavigationBar: _mainWrapperBottomNavBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _mainWrapperFab(),
    );
  }

  // Bottom Navigation Bar - MainWrapper Widget
  BottomAppBar _mainWrapperBottomNavBar(BuildContext context) {
    return BottomAppBar(
      notchMargin: 5.0,
      shape: const CircularNotchedRectangle(),
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomAppBarItem(
                  context,
                  defaultIcon: IconlyLight.home,
                  page: 0,
                  label: "Home",
                  filledIcon: IconlyBold.home,
                ),
                _bottomAppBarItem(
                  context,
                  defaultIcon: IconlyLight.bag,
                  page: 1,
                  label: "Product",
                  filledIcon: IconlyBold.bag,
                ),
                const SizedBox(
                  width: 80,
                  height: 20,
                ),
                _bottomAppBarItem(
                  context,
                  defaultIcon: IconlyLight.document,
                  page: 2,
                  label: "Stocks",
                  filledIcon: IconlyBold.document,
                ),
                _bottomAppBarItem(
                  context,
                  defaultIcon: IconlyLight.user_1,
                  page: 3,
                  label: "Sales",
                  filledIcon: IconlyBold.user_3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Floating Action Button - MainWrapper Widget
  SpeedDial _mainWrapperFab() {
    return SpeedDial(
      activeIcon: Icons.close,
      icon: Icons.add,
      backgroundColor: Colors.amber,
      curve: Curves.easeInOut,
      // animation
      overlayColor: Colors.black,
      children: [
        SpeedDialChild(
            backgroundColor: Colors.grey.shade800,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProduct()),
              );
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.amber),
            labelWidget:
                const Text("Product", style: TextStyle(color: Colors.white))),
        SpeedDialChild(
            backgroundColor: Colors.grey.shade800,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStock()),
              );
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.amber),
            labelWidget:
                const Text("Stock", style: TextStyle(color: Colors.white))),
        SpeedDialChild(
            backgroundColor: Colors.grey.shade800,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSales()),
              );
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.amber),
            labelWidget:
                const Text("Sales", style: TextStyle(color: Colors.white))),
      ],
      child: const Icon(Icons.add),
    );
  }

  // Body - MainWrapper Widget
  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: (int page) => onPageChanged(page),
      controller: pageController,
      children: topLevelPages,
    );
  }

  // Bottom Navigation Bar Single item - MainWrapper Widget
  Widget _bottomAppBarItem(
    BuildContext context, {
    required defaultIcon,
    required page,
    required label,
    required filledIcon,
  }) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);

        pageController.animateToPage(page,
            duration: const Duration(milliseconds: 10),
            curve: Curves.fastLinearToSlowEaseIn);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Icon(
              context.watch<BottomNavCubit>().state == page
                  ? filledIcon
                  : defaultIcon,
              color: context.watch<BottomNavCubit>().state == page
                  ? Colors.black
                  : Colors.black.withOpacity(.5),
              size: 26,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              label,
              style: GoogleFonts.aBeeZee(
                color: context.watch<BottomNavCubit>().state == page
                    ? Colors.black
                    : Colors.black.withOpacity(.5),
                fontSize: 13,
                fontWeight: context.watch<BottomNavCubit>().state == page
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
