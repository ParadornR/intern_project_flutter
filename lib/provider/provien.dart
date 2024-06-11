// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Province extends ChangeNotifier {
  List dataProvince = [];
  List dataAmphure = [];
  List dataTambon = [];

  bool dataLoaded = false;
  Future<void> getApiTestProvince() async {
    try {
      String url =
          'https://raw.githubusercontent.com/kongvut/thai-province-data/master/api_province.json';
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // print('jsonResponse: ${jsonResponse[0]}');
        dataProvince = [];
        dataProvince.addAll(jsonResponse);
        // log(data.runtimeType.toString());
        String error = jsonResponse["error"];

        if (error.isEmpty) {
          // careList = jsonResponse['data'];
        } else {
          // Fluttertoast.showToast(msg: error);
        }
      } else {
        // Fluttertoast.showToast(msg: 'Server error');
      }
    } catch (error) {
      print('Error in getApiTest: $error');
      // Fluttertoast.showToast(msg: 'An unexpected error occurred');
    }

    notifyListeners();
  }

  Future<void> getApiTestAmphure() async {
    try {
      String url =
          'https://raw.githubusercontent.com/kongvut/thai-province-data/master/api_amphure.json';
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // print('jsonResponse: ${jsonResponse[0]}');
        dataAmphure = [];
        dataAmphure.addAll(jsonResponse);
        log(dataAmphure.runtimeType.toString());
        String error = jsonResponse["error"];

        if (error.isEmpty) {
          // careList = jsonResponse['data'];
        } else {
          // Fluttertoast.showToast(msg: error);
        }
      } else {
        // Fluttertoast.showToast(msg: 'Server error');
      }
    } catch (error) {
      print('Error in getApiTest: $error');
      // Fluttertoast.showToast(msg: 'An unexpected error occurred');
    }

    notifyListeners();
  }

  Future<void> getApiTestTambon() async {
    try {
      String url =
          'https://raw.githubusercontent.com/kongvut/thai-province-data/master/api_tambon.json';
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // print('jsonResponse: ${jsonResponse[0]}');
        dataTambon = [];
        dataTambon.addAll(jsonResponse);
        // log(dataTambon.runtimeType.toString());
        String error = jsonResponse["error"];

        if (error.isEmpty) {
          // careList = jsonResponse['data'];
        } else {
          // Fluttertoast.showToast(msg: error);
        }
      } else {
        // Fluttertoast.showToast(msg: 'Server error');
      }
    } catch (error) {
      print('Error in getApiTest: $error');
      // Fluttertoast.showToast(msg: 'An unexpected error occurred');
    }

    notifyListeners();
  }
}
