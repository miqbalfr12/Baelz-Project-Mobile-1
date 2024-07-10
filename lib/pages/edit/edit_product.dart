import 'package:flutter/material.dart';
import 'package:uas/modal/modal_content.dart';

import 'package:image_input/image_input.dart';
import 'package:uas/models/product_model.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.product});

  final Product product;

  @override
  EditProductState createState() => EditProductState();
}

class EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  String _itemName = "";
  num _itemPrice = 0;
  num _itemQty = 0;
  String _itemAttr = "";
  num _itemWeight = 0;
  final List<XFile> _imageInputImages = [];

  @override
  Widget build(BuildContext context) {
    print(widget.product);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Edit Product'),
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
                child: formEditProduct(),
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
                        print({
                          "name": _itemName,
                          "attr": _itemAttr,
                          "price": _itemPrice,
                          "qty": _itemQty,
                          "weight": _itemWeight,
                          "id": widget.product.id,
                          "image": _imageInputImages
                        });
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.amber,
                          builder: (BuildContext context) {
                            return ModalContent(title: 'Edit Product', obj: {
                              "name": _itemName,
                              "attr": _itemAttr,
                              "price": _itemPrice,
                              "qty": _itemQty,
                              "weight": _itemWeight,
                              "id": widget.product.id,
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
                        Icon(Icons.edit, color: Colors.black),
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
                      // Aksi yang dijalankan saat tombol ditekan
                      print('Tombol 2 ditekan');
                      // pop the current page
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

  Form formEditProduct() {
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
            initialValue: widget.product.name,
            onSaved: (value) => _itemName = value!,
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
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
            initialValue: widget.product.price.toString(),
            onSaved: (value) => _itemPrice = num.parse(value!),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.number,
            cursorColor: Colors.amber,
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
            initialValue: widget.product.qty.toString(),
            onSaved: (value) => _itemQty = num.parse(value!),
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: Colors.grey.shade700),
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
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
            initialValue: widget.product.attr,
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
            initialValue: widget.product.weight.toString(),
            onSaved: (value) => _itemWeight = num.parse(value!),
          ),
        ],
      ),
    );
  }
}
