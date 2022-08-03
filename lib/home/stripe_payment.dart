//import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
//
// class StripeTransactionResponse {
//   String message;
//   bool success;
//
//   StripeTransactionResponse({
//     required this.message,
//     required this.success,
//   });
// }
//
// class StripeServices {
//   static String apiBase = 'http://api.stripe.com/v1';
//   static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
//  static Uri paymentApiUri=Uri.parse(paymentApiUrl);
//   static String secret = 'sk_test_51LPWpBEu20JFnbILdCxViZ2d4FqE28GRcPO3u1TlfSoGEqhXKo0jA4Bfy3WLcsbvA9ouqDUZ5BWtL2PZh9dREYOF00UkXZr9Wl';
//   static Map<String, String> headers = {
//     'Authorization': 'Bearer $secret',
//     'Content-Type': 'application/x-www-form-urlencoded',
//   };
//
//   var paymentIntent;
//
//   // static init() {
//   //   StripePayment.setOptions(
//   //     StripeOptions(
//   //         publishableKey:
//   //             'pk_test_51LPWpBEu20JFnbILgPFSky2JOKTiC3G4V8dlVk9JL2OPWvAdy7lQZyywhWdZVaOUYDPWn3kl5cS5gpJ20f6rg8PU00WBVcvxQ6',
//   //         androidPayMode: 'test',
//   //         merchantId: 'Test',
//   //     ),);
//
//
//   }
//
//
//
//   // static Future<StripeTransactionResponse> payNowHandler({required String amount,required String currency})async{
//   //   try{
//   //     var paymentMethod=await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
//   //     var paymentIntent=await StripeServices.createPaymentIntent(amount, currency);
//   //     var response=await StripePayment.confirmPaymentIntent(PaymentIntent(clientSecret: paymentIntent['client_secret'],paymentMethodId: paymentMethod.id));
//   //
//   //     if(response.status=='succeeded'){
//   //       print('response success message :${response.status}');
//   //        return StripeTransactionResponse(message: 'transaction success', success: true);
//   //
//   //     }else{
//   //       print('response failed message :${response.status}');
//   //       return StripeTransactionResponse(message: 'transaction failed', success: false);
//   //     }
//   //   }catch(error){
//   //     print('catch message :${error.toString()}');
//   //     return StripeTransactionResponse(message: 'transaction failed on catch block', success: false);
//   //   }
//   //   // on PlatformException catch (error){
//   //   //   return StripeServices.getErrorAndAnalyze(error);
//   //   // }
//   // }
//
//
//   // static getErrorAndAnalyze(error){
//   //   String message='something went wrong';
//   //   if(error.code=='cancelled'){
//   //     message='Transaction canceled';
//   //   }
//   //   return StripeTransactionResponse(message: message, success: false);
//   // }
//
//
// }
