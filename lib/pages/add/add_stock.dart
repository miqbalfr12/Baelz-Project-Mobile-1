import 'package:flutter/material.dart';
import 'package:uas/modal/modal_content.dart';

import 'package:image_input/image_input.dart';

class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  AddStockState createState() => AddStockState();
}

class AddStockState extends State<AddStock> {
  final _formKey = GlobalKey<FormState>();
  String _itemName = "";
  int _itemQty = 0;
  String _itemAttr = "";
  num _itemWeight = 0;
  final List<XFile> _imageInputImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Tambah Stock'),
      ),
      backgroundColor: Colors.amber, // Background color of the main Scaffold
      body: Stack(
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
                child: formAddStock(),
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
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.amber,
                          builder: (BuildContext context) {
                            return ModalContent(title: 'Add Stock', obj: {
                              "name": _itemName,
                              "attr": _itemAttr,
                              "qty": _itemQty,
                              "weight": _itemWeight,
                              "image": _imageInputImages
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

  Form formAddStock() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImageInput(
            images: _imageInputImages,
            imageContainerDecoration: BoxDecoration(
              border: Border.all(
                color: Colors.amber,
                width: 2.0,
              ),
            ),
            addImageContainerDecoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(100.0),
            ),
            allowEdit: true,
            allowMaxImage: 1,
            onImageSelected: (image) {
              setState(() {
                _imageInputImages.add(image);
              });
            },
            onImageRemoved: (image, index) {
              setState(() {
                _imageInputImages.remove(image);
              });
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              labelText: "Nama Barang",
              prefixIcon: const Icon(
                Icons.shopping_bag_outlined, // Change to your desired icon
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
            decoration: InputDecoration(
              labelText: "Quantity",
              prefixIcon: const Icon(
                Icons.view_in_ar_outlined, // Change to your desired icon
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
            decoration: InputDecoration(
              labelText: "Attribute",
              prefixIcon: const Icon(
                Icons.category_outlined, // Change to your desired icon
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
            decoration: InputDecoration(
              labelText: "Weight",
              prefixIcon: const Icon(
                Icons.scale_rounded, // Change to your desired icon
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
            onSaved: (value) => _itemWeight = num.parse(value!),
          ),
        ],
      ),
    );
  }
}
