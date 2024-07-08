import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas/modal/view_image_dialog.dart';
import 'package:uas/models/stock_model.dart';
import 'package:uas/pages/details/detail_stock.dart';
import 'package:uas/services/api_services.dart';
import 'package:intl/intl.dart';

class StocksPage extends StatefulWidget {
  const StocksPage({super.key});

  @override
  State<StocksPage> createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  final ApiService apiService = ApiService();
  late List<Stock> stocks = [];
  late List<Stock> originalStocks = [];
  bool isLoading = true;
  late List<String> issuers = [];
  String? selectedIssuer;

  @override
  void initState() {
    super.initState();
    _fetchStocks();
  }

  Future<void> _fetchStocks() async {
    try {
      List<Stock> fetchedStocks = await apiService.getStocks();
      List<String> allIssuers =
          fetchedStocks.map((stock) => stock.issuer).toList();
      List<String> uniqueIssuers = allIssuers.toSet().toList();
      print(uniqueIssuers);
      setState(() {
        issuers = uniqueIssuers;
        stocks = fetchedStocks;
        originalStocks = fetchedStocks;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _searchStock(String query) {
    setState(() {
      if (query.isNotEmpty) {
        stocks = originalStocks.where((stock) {
          return stock.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        stocks = originalStocks.toList();
      }
    });
  }

  void _filterStockByIssuer(String? issuer) {
    setState(() {
      selectedIssuer = issuer;
      if (issuer != null && issuer.isNotEmpty) {
        stocks = originalStocks.where((stock) {
          return stock.issuer == issuer;
        }).toList();
      } else {
        stocks = originalStocks.toList();
      }
    });
  }

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _fetchStocks,
        backgroundColor: Colors.grey.shade600,
        color: Colors.amber,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.amber,
              ))
            : Scaffold(
                backgroundColor: Colors.black,
                body: SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Stock Page!",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Menampilkan List Stock",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                cursorColor: Colors.amber,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade800,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Search Product",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(
                                    CupertinoIcons.search,
                                    color: Colors.grey.shade600,
                                    size: 20,
                                  ),
                                ),
                                onChanged: (value) {
                                  _searchStock(value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Spacer antara TextField dan Button
                          SizedBox(
                            height: 40,
                            child: DropdownButton<String>(
                              value: selectedIssuer,
                              hint: Text(
                                'Filter by Issuer',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              dropdownColor: Colors.grey.shade800,
                              iconEnabledColor: Colors.amber,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.amber,
                              ),
                              onChanged: (String? newValue) {
                                _filterStockByIssuer(newValue);
                              },
                              items: issuers.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    stocks.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            itemCount: stocks.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  previewImage(context, index, stocks).then(
                                      (value) => {
                                            _fetchStocks(),
                                            _filterStockByIssuer(null)
                                          });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.network(
                                            'https://api.kartel.dev/stocks/${stocks[index].id}/image',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              // This widget is shown when the image fails to load
                                              return Center(
                                                child: Icon(
                                                  Icons
                                                      .image_not_supported, // You can use any icon or widget here
                                                  color: Colors.grey.shade700,
                                                ),
                                              );
                                            },
                                            loadingBuilder:
                                                (context, child, progress) {
                                              // This widget is shown while the image is loading
                                              if (progress == null) {
                                                return child;
                                              } else {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(), // Show a loading indicator
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  stocks[index].name,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "${stocks[index].weight} kg x ${stocks[index].qty} ${stocks[index].attr}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  stocks[index].issuer,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailStock(
                                                            id: stocks[index]
                                                                .id),
                                                  ),
                                                ).then((value) => {
                                                      _fetchStocks(),
                                                      _filterStockByIssuer(
                                                          null),
                                                    });
                                              },
                                              child: Container(
                                                width: 80,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade800,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Detail",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ))));
  }
}
