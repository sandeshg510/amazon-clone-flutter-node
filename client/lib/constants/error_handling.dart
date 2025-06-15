import 'dart:convert';

import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required Function? onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess!();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)["msg"]);
      print('Response body: ${response.body}');

      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)["error"]);
      print('Response body: ${response.body}');

      break;
    default:
      showSnackBar(context, response.body);
      print('Response body: ${response.body}');
  }
}
