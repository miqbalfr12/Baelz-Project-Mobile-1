import 'package:flutter/material.dart';
import 'package:uas/modal/modal_content.dart';
import 'package:uas/models/sales_model.dart';

class EditSales extends StatefulWidget {
  const EditSales({super.key, required this.sales});

  final Sales sales;

  @override
  EditSalesState createState() => EditSalesState();
}

class EditSalesState extends State<EditSales> {
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

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.sales.status;
    _dateController.text = widget.sales.date;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.sales.date),
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

  final TextEditingController _dateController = TextEditingController();

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
        title: const Text('Edit Sales'),
      ),
      backgroundColor: Colors.amber, // Background color of the main Scaffold
      body: Stack(
        children: [
          Container(
            width: double.infinity, // Set width to full width available
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: formEditSales(),
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
                        print("Editing Sales");
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
                            return ModalContent(title: 'Edit Sales', obj: {
                              "id": widget.sales.id,
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
                          'Edit',
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

  Form formEditSales() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            initialValue: widget.sales.buyer,
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
            initialValue: widget.sales.phone,
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
