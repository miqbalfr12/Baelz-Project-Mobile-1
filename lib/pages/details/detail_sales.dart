import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas/modal/modal_content.dart';
import 'package:uas/models/sales_model.dart';
import 'package:uas/pages/edit/edit_sales.dart';
import 'package:uas/services/api_services.dart';

class DetailSales extends StatefulWidget {
  const DetailSales({super.key, required this.id});

  final String id;

  @override
  DetailSalesState createState() => DetailSalesState();
}

class DetailSalesState extends State<DetailSales> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  String _itemBuyer = "";
  String _itemPhone = "";
  String _itemDate = "";
  String _itemStatus = "";
  int _createdAt = 0;
  int _updatedAt = 0;
  String _itemIssuer = "";
  late Sales _sales;

  DateTime? _selectedDate;

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
      Sales fetchedSales = await apiService.getSales(id);
      print(fetchedSales);
      setState(() {
        _itemBuyer = fetchedSales.buyer;
        _itemPhone = fetchedSales.phone;
        _itemStatus = fetchedSales.status;
        _itemDate = fetchedSales.date;
        _createdAt = fetchedSales.createdAt;
        _updatedAt = fetchedSales.updatedAt;
        _itemIssuer = fetchedSales.issuer;
        _dateController.text = fetchedSales.date;
        _sales = fetchedSales;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _itemDate = "${picked.toLocal()}".split(' ')[0]; // Format as yyyy-mm-dd
        _dateController.text = _itemDate;
      });
    }
  }

  TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Detail Sales'),
      ),
      backgroundColor: Colors.amber, // Background color of the main Scaffold
      body: _isLoading // Show loading indicator if data is being fetched
          ? Container(
              width: double.infinity, // Set width to full width available
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
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
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: formDetailSales(),
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
                                                      title: 'Delete Sales',
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
                            // push edit page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditSales(sales: _sales),
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
                        const SizedBox(width: 10),
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

  Form formDetailSales() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            initialValue: _itemBuyer,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Nama Buyer",
              prefixIcon: const Icon(
                Icons.assignment_ind_rounded, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nama Buyer tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemBuyer = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            initialValue: _itemPhone,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Nomor Buyer",
              prefixIcon: const Icon(
                Icons.phone, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nomor buyer tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemPhone = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            initialValue: _itemStatus,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Status",
              prefixIcon: const Icon(
                Icons.description, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Status tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemStatus = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
            initialValue: _itemDate,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Status",
              prefixIcon: const Icon(
                Icons.date_range_rounded, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Status tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemDate = value!,
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
                Icons.create_new_folder_rounded, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
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
                Icons.edit, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
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
                Icons.assignment_ind_rounded, // Change to your desired icon
              ),
              focusColor: Colors.amber,
              prefixIconColor: Colors.grey.shade700,
              floatingLabelStyle: const TextStyle(
                color: Colors.amber,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0), // Set border radius
                borderSide: const BorderSide(
                  color: Colors.amber, // Set border color
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
