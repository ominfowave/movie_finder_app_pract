import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'string.dart';

class Utils{

  // check internet is connected or not
  static Future<bool> isInternetConnected() async {
    if (await InternetConnectionChecker().hasConnection) {
      // Mobile data detected & internet connection confirmed.
      return true;
    } else {
      // Mobile data detected but no internet connection found.
      return false;
    }
  }

  //common method for display error Msg in toast
  static showErrorMsg(BuildContext context,String errMsg) {
    var snackBar = SnackBar(content: Text(errMsg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static getErrorApi(DioException e, Function(String p1) onError){
    if(e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.unknown){
      onError(CustomString.toastConnectionTimeout);
    } else if(e.response!.statusCode == 400){
      onError(e.response!.data.toString());
    }else {
      onError(CustomString.toastSomethingWentWrong);
    }
  }


}