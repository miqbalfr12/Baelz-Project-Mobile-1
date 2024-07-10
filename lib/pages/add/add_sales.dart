import 'package:flutter/material.dart';
import 'package:uas/modal/modal_content.dart';

class AddSales extends StatefulWidget {
  const AddSales({super.key});

  @override
  AddSalesState createState() => AddSalesState();
}

class AddSalesState extends State<AddSales> {
  final _formKey = GlobalKey<FormState>();
  String _itemBuyer = "";
  String _itemStatus = "";
  String _itemPhone = "";
  String _itemDate = "";
  DateTime? _selectedDate;
  String? _selectedStatus;
  final List<String> _statusOptions = [
    'Done',
    'Cicil',
    'Belum Bayar',
    'Pending',
    'Cancel'
  ];

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
        title: const Text('Tambah Sales'),
      ),
      backgroundColor: Colors.amber, // Background color of the main Scaffold
      body: Stack(
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
                child: formAddSales(),
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Handle form submission with _itemBuyer and _itemDate
                        // You can potentially call a function to add stock
                        print(
                            "Adding Sales for $_itemBuyer with stock $_itemDate ");
                        print({
                          "buyer": _itemBuyer,
                          "phone": _itemPhone,
                          "status": _itemStatus,
                          "date": _itemDate
                        });
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.amber,
                          builder: (BuildContext context) {
                            return ModalContent(title: 'Add Sales', obj: {
                              "buyer": _itemBuyer,
                              "phone": _itemPhone,
                              "status": _itemStatus,
                              "date": _itemDate
                            });
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Tambahkan',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
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

  Form formAddSales() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Nama Buyer",
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
            decoration: InputDecoration(
              labelText: "Nomor Buyer",
              prefixIcon: const Icon(
                Icons.phone,
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
                return "Nomor buyer tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemPhone = value!,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            style: TextStyle(color: Colors.grey.shade700),
            decoration: InputDecoration(
              labelText: "Status",
              prefixIcon: const Icon(
                Icons.description,
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
            items: _statusOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue;
              });
            },
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
            controller: _dateController,
            style: TextStyle(color: Colors.grey.shade700),
            readOnly: true, // Prevent keyboard from appearing
            onTap: () => _selectDate(context),
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Tanggal",
              prefixIcon: const Icon(
                Icons.date_range_rounded,
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
                return "Tanggal tidak boleh kosong";
              }
              return null;
            },
            onSaved: (value) => _itemDate = value!,
          ),
        ],
      ),
    );
  }
}
