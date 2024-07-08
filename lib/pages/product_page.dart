import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas/modal/view_image_dialog.dart';
import 'package:uas/models/product_model.dart';
import 'package:uas/pages/details/detail_product.dart';
import 'package:uas/services/api_services.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ApiService apiService = ApiService();
  late List<Product> products = [];
  late List<Product> originalProducts = [];
  bool isLoading = true;
  late List<String> issuers = [];
  String? selectedIssuer;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      print('fetching data');
      List<Product> fetchedProducts = await apiService.getProducts();
      print(fetchedProducts);
      List<String> allIssuers =
          fetchedProducts.map((product) => product.issuer).toList();
      List<String> uniqueIssuers = allIssuers.toSet().toList();
      print(uniqueIssuers);
      setState(() {
        issuers = uniqueIssuers;
        products = fetchedProducts;
        originalProducts = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _searchProduct(String query) {
    setState(() {
      if (query.isNotEmpty) {
        products = originalProducts.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        products = originalProducts.toList();
      }
    });
  }

  void _filterProductsByIssuer(String? issuer) {
    setState(() {
      selectedIssuer = issuer;
      if (issuer != null && issuer.isNotEmpty) {
        products = originalProducts.where((product) {
          return product.issuer == issuer;
        }).toList();
      } else {
        products = originalProducts.toList();
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
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: RefreshIndicator(
        onRefresh: _fetchProducts,
        backgroundColor: Colors.grey.shade600,
        color: Colors.amber,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.amber,
              ))
            : SingleChildScrollView(
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
                              CupertinoIcons.bag,
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
                                    "Product Page!",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Menampilkan List Product",
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
                                  _searchProduct(value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                                _filterProductsByIssuer(newValue);
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  previewImage(
                                    context,
                                    index,
                                    products,
                                  ).then((value) => {
                                        _fetchProducts(),
                                        _filterProductsByIssuer(null)
                                      });
                                },
                                child: Container(
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
                                            'https://api.kartel.dev/products/${products[index].id}/image',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey.shade700,
                                                ),
                                              );
                                            },
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null) {
                                                return child;
                                              } else {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
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
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                    products[index].name,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                ),
                                                Text(
                                                  "${products[index].weight} kg x ${products[index].qty} ${products[index].attr}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailProduct(
                                                id: products[index].id,
                                              ),
                                            ),
                                          ).then((value) => {
                                                _fetchProducts(),
                                                _filterProductsByIssuer(null)
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
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Price: ${currencyFormatter.format(products[index].price)}',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      products[index].issuer,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
