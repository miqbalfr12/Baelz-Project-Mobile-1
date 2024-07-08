import 'package:flutter/material.dart';
import 'package:uas/services/api_services.dart';

class ModalContent extends StatefulWidget {
  const ModalContent({super.key, required this.title, this.obj = const {}});
  final Map<String, dynamic> obj;
  final String title;

  @override
  _ModalContentState createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  bool isLoading = true;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String title = widget.title;
    Map<String, dynamic> obj = widget.obj;

    print('Title: $title');
    print('obj: $obj');

    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay

    if (mounted) {
      if (title == "Add Product") {
        try {
          final response = await ApiService().createProduct(
              obj['name'],
              obj['price'],
              obj['qty'],
              obj['attr'],
              obj['weight'],
              obj['image']);

          if (response.statusCode == 201) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
      if (title == "Add Stock") {
        try {
          final response = await ApiService().createStock(obj['name'],
              obj['qty'], obj['attr'], obj['weight'], obj['image']);

          if (response.statusCode == 201) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
      if (title == "Add Sales") {
        try {
          final response = await ApiService().createSales(
              obj['buyer'], obj['phone'], obj['date'], obj['status']);

          if (response.statusCode == 201) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
      if (title == "Edit Product") {
        try {
          final response = await ApiService().editProduct(
              obj['name'],
              obj['price'],
              obj['qty'],
              obj['attr'],
              obj['weight'],
              obj['id'],
              obj['image']);

          if (response.statusCode == 200) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
      if (title == "Edit Stock") {
        try {
          final response = await ApiService().editStock(obj['name'], obj['qty'],
              obj['attr'], obj['weight'], obj['id'], obj['image']);

          if (response.statusCode == 200) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
      if (title == "Edit Sales") {
        try {
          final response = await ApiService().editSales(obj['buyer'],
              obj['phone'], obj['date'], obj['status'], obj['id']);

          if (response.statusCode == 200) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
      if (title == "Delete Product") {
        try {
          final response = await ApiService().delProduct(obj['id']);
          print(response.statusCode);
          if (response.statusCode == 204) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
      if (title == "Delete Stock") {
        try {
          final response = await ApiService().delStock(obj['id']);
          print(response.statusCode);
          if (response.statusCode == 204) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
      if (title == "Delete Sales") {
        try {
          final response = await ApiService().delSales(obj['id']);
          print(response.statusCode);
          if (response.statusCode == 204) {
            setState(() {
              isSuccess = true;
              isLoading = false; // Assume response status is 200
            });
          } else {
            setState(() {
              isSuccess = false;
              isLoading = false; // Assume response status is 200
            });
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            isSuccess = false;
            isLoading = false; // Assume response status is 200
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Image.asset(
                  isLoading
                      ? 'assets/gif/loading.gif'
                      : isSuccess
                          ? 'assets/gif/success.gif'
                          : 'assets/gif/fail.gif',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% of screen width
                child: isLoading
                    ? null
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade900,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
