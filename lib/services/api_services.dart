import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uas/models/sales_model.dart';
import 'package:uas/models/stock_model.dart';
import 'package:uas/models/product_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'https://api.kartel.dev';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((user) => Product.fromJson(user))
          // .where((user) => user.issuer == "MIqbalFR12")
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Stock>> getStocks() async {
    final response = await http.get(Uri.parse('$baseUrl/stocks'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((user) => Stock.fromJson(user))
          // .where((user) => user.issuer == "MIqbalFR12")
          .toList();
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  Future<List<Sales>> getSaless() async {
    final response = await http.get(Uri.parse('$baseUrl/sales'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((user) => Sales.fromJson(user))
          // .where((user) => user.issuer == "admin")
          .toList();
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<Product> getProduct(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Stock> getStock(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/stocks/$id'));
    if (response.statusCode == 200) {
      return Stock.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Stock');
    }
  }

  Future<Sales> getSales(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/sales/$id'));
    if (response.statusCode == 200) {
      return Sales.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Sales');
    }
  }

  Future<http.Response> delProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 204) {
      return response;
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<http.Response> delStock(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/stocks/$id'));
    if (response.statusCode == 204) {
      return response;
    } else {
      throw Exception('Failed to load Stock');
    }
  }

  Future<http.Response> delSales(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/sales/$id'));
    if (response.statusCode == 204) {
      return response;
    } else {
      throw Exception('Failed to load Sales');
    }
  }

  Future<http.Response> editProduct(String name, int price, int qty,
      String attr, num weight, String id, List<XFile> image) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      body: json.encode({
        'name': name,
        'price': price,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        "issuer": 'MIqbalFR12'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (image.isNotEmpty) {
      print(image[0]);

      final File imageFile = File(image[0].path);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products/$id/image'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'png'), // Sesuaikan jika bukan jpeg
        ),
      );
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      var response2 = await request.send();
      print(response2.statusCode);
      if (response2.statusCode != 201) {
        throw Exception('Failed to create product');
      }
      return response;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to create product');
    }

    return response;
  }

  Future<http.Response> editStock(String name, int qty, String attr, num weight,
      String id, List<XFile> image) async {
    final response = await http.put(
      Uri.parse('$baseUrl/stocks/$id'),
      body: json.encode({
        'name': name,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        "issuer": 'MIqbalFR12'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (image.isNotEmpty) {
      print(image[0]);

      final File imageFile = File(image[0].path);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/stocks/$id/image'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'png'), // Sesuaikan jika bukan jpeg
        ),
      );
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      var response2 = await request.send();
      print(response2.statusCode);
      if (response2.statusCode != 201) {
        throw Exception('Failed to upload image');
      }
      return response;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to create stock');
    }

    return response;
  }

  Future<http.Response> editSales(
      String buyer, String phone, String date, String status, String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/sales/$id'),
      body: json.encode({
        'buyer': buyer,
        'phone': phone,
        'date': date,
        'status': status,
        "issuer": 'MIqbalFR12'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create stock');
    }

    return response;
  }

  Future<http.Response> createProduct(String name, int price, int qty,
      String attr, num weight, List<XFile> image) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      body: json.encode({
        'name': name,
        'price': price,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        "issuer": 'MIqbalFR12'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      if (image.isNotEmpty) {
        print(image[0]);

        final File imageFile = File(image[0].path);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '$baseUrl/products/${json.decode(response.body)['id']}/image'),
        );
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', 'png'), // Sesuaikan jika bukan jpeg
          ),
        );
        request.headers.addAll({
          'Content-Type': 'multipart/form-data',
        });

        var response2 = await request.send();
        print(response2.statusCode);
        if (response2.statusCode != 201) {
          throw Exception('Failed to create product');
        }
        return response;
      }
    }

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }

    return response;
  }

  Future<http.Response> createStock(
      String name, int qty, String attr, num weight, List<XFile> image) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stocks'),
      body: json.encode({
        'name': name,
        'qty': qty,
        'attr': attr,
        'weight': weight,
        "issuer": 'MIqbalFR12'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      if (image.isNotEmpty) {
        print(image[0]);

        final File imageFile = File(image[0].path);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '$baseUrl/stocks/${json.decode(response.body)['id']}/image'),
        );
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', 'png'), // Sesuaikan jika bukan jpeg
          ),
        );
        request.headers.addAll({
          'Content-Type': 'multipart/form-data',
        });

        var response2 = await request.send();
        print(response2.statusCode);
        if (response2.statusCode != 201) {
          throw Exception('Failed to create stock');
        }
        return response;
      }
    }

    if (response.statusCode != 201) {
      throw Exception('Failed to create stock');
    }

    return response;
  }

  Future<http.Response> createSales(
      String buyer, String phone, String date, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sales'),
      body: json.encode({
        'buyer': buyer,
        'phone': phone,
        'date': date,
        'status': status,
        "issuer": 'MIqbalFR12'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create stock');
    }

    return response;
  }
}
