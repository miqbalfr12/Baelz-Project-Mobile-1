import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas/pages/add/add_product.dart';
import 'package:uas/pages/add/add_sales.dart';
import 'package:uas/pages/add/add_stock.dart';
import 'package:uas/services/api_services.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;

  const HomePage({Key? key, required this.pageController}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DataFetcher fetcher;
  List<Map<String, dynamic>> combinedResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetcher = DataFetcher();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Map<String, dynamic>> results = await fetcher.fetchAllData();
      setState(() {
        combinedResults = results;
        isLoading = false;
      });
      print(results);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade800,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.bag,
                                color: Colors.grey.shade600,
                                size: 80,
                              ),
                              const SizedBox(width: 10),
                              isLoading
                                  ? const Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.amber)))
                                  : Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${combinedResults[0]['total']} Products",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${combinedResults[0]['issuers']} Issuer",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey.shade600,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            iconColor: Colors.amber,
                          ),
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddProduct()))
                                .then((value) => fetchData());
                          },
                          icon: const Icon(Icons.add),
                          label: Text("Tambah Product",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
                              ))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade800,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.news,
                                color: Colors.grey.shade600,
                                size: 80,
                              ),
                              const SizedBox(width: 10),
                              isLoading
                                  ? const Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.amber)))
                                  : Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${combinedResults[1]['total']} Stocks",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${combinedResults[1]['issuers']} Issuer",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey.shade600,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            iconColor: Colors.amber,
                          ),
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const AddStock()))
                                .then((value) => fetchData());
                          },
                          icon: const Icon(Icons.add),
                          label: Text("Tambah Stock",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
                              ))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.pageController.animateToPage(
                            3,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade800,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.person_2_fill,
                                color: Colors.grey.shade600,
                                size: 80,
                              ),
                              const SizedBox(width: 10),
                              isLoading
                                  ? const Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.amber)))
                                  : Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${combinedResults[2]['total']} Sales",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${combinedResults[2]['issuers']} Issuer",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey.shade600,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            iconColor: Colors.amber,
                          ),
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const AddSales()))
                                .then((value) => fetchData());
                          },
                          icon: const Icon(Icons.add),
                          label: Text("Tambah Sales",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
