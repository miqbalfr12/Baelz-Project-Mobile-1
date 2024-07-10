import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas/modal/modal_content.dart';
import 'package:uas/models/product_model.dart';
import 'package:uas/pages/edit/edit_product.dart';
import 'package:uas/services/api_services.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key, required this.id});

  final String id;

  @override
  DetailProductState createState() => DetailProductState();
}

class DetailProductState extends State<DetailProduct> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  String _itemName = "";
  int _itemPrice = 0;
  int _itemQty = 0;
  int _createdAt = 0;
  int _updatedAt = 0;
  String _itemAttr = "";
  String _itemIssuer = "";
  num _itemWeight = 0;
  late Product _product;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct(widget.id);
  }

  Future<void> _fetchProduct(id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      print("fetching data");
      Product fetchedProduct = await apiService.getProduct(id);
      print(fetchedProduct);
      setState(() {
        _itemName = fetchedProduct.name;
        _itemPrice = fetchedProduct.price;
        _itemQty = fetchedProduct.qty;
        _itemAttr = fetchedProduct.attr;
        _itemWeight = fetchedProduct.weight;
        _createdAt = fetchedProduct.createdAt;
        _updatedAt = fetchedProduct.updatedAt;
        _itemIssuer = fetchedProduct.issuer;
        _product = fetchedProduct;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Detail Product'),
      ),
      backgroundColor: Colors.amber, // Background color of the main Scaffold
      body: _isLoading // Show loading indicator if data is being fetched
          ? Container(
              width: double.infinity, // Set width to full width available
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Image.asset('assets/gif/loading.gif'),
                ),
              ),
            )
          : Stack(
              children: [
                Container(
                  width: double.infinity, // Set width to full width available
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: formDetailProduct(),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                        backgroundColor: Colors.grey.shade900,
                                        title: const Text('Delete Confirmation',
                                            style:
                                                TextStyle(color: Colors.amber)),
                                        content: const Text(
                                            'Are you sure you want to delete this item?',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        actions: [
                                          TextButton(
                                            onPressed: () => {
                                              Navigator.pop(context),
                                            },
                                            child: const Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors.amber)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                context: context,
                                                backgroundColor: Colors.amber,
                                                builder:
                                                    (BuildContext context) {
                                                  return ModalContent(
                                                      title: 'Delete Product',
                                                      obj: {"id": widget.id});
                                                },
                                              );
                                            },
                                            child: const Text('Confirm',
                                                style: TextStyle(
                                                    color: Colors.amber)),
                                          )
                                        ]));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade800,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete, color: Colors.grey.shade200),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProduct(product: _product),
                              ),
                            ).then((value) => _fetchProduct(widget.id));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit, color: Colors.grey.shade800),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close, color: Colors.amber),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Form formDetailProduct() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Image.network(
            'https://api.kartel.dev/products/${widget.id}/image',
            errorBuilder: (context, error, stackTrace) {
              // This widget is shown when the image fails to load
              return Center(
                child: Icon(
                  Icons
                      .image_not_supported, // You can use any icon or widget here
                  color: Colors.grey.shade700,
                ),
              );
            },
            loadingBuilder: (context, child, progress) {
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
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            initialValue: _itemName,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Nama Barang",
              prefixIcon: const Icon(
                Icons.shopping_bag_outlined,
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nama barang tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemName = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            initialValue: _itemPrice.toString(),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Price",
              prefixIcon: const Icon(
                Icons.monetization_on_rounded,
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Price tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemPrice = int.parse(value!),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            initialValue: _itemQty.toString(),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Quantity",
              prefixIcon: const Icon(
                Icons.view_in_ar_outlined,
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Quantity tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemQty = int.parse(value!),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            initialValue: _itemAttr,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Attribute",
              prefixIcon: const Icon(
                Icons.category_outlined,
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Attribute tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemAttr = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            initialValue: _itemWeight.toString(),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Weight",
              prefixIcon: const Icon(
                Icons.scale_rounded,
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Weight tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemWeight = num.parse(value!),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            initialValue: DateFormat('yyyy-MM-dd HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(_createdAt)),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Created At",
              prefixIcon: const Icon(
                Icons.create_new_folder_rounded,
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Weight tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _createdAt = int.parse(value!),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            initialValue: DateFormat('yyyy-MM-dd HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(_updatedAt)),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Upated At",
              prefixIcon: const Icon(
                Icons.edit,
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Weight tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _updatedAt = int.parse(value!),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            cursorColor: Colors.amber,
            initialValue: _itemIssuer.toString(),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Issuer",
              prefixIcon: const Icon(
                Icons.assignment_ind_rounded,
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Weight tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemIssuer = value!,
          ),
        ],
      ),
    );
  }
}
