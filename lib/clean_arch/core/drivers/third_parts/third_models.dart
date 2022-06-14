import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterThirdsModule {
  @factoryMethod
  Dio dio() => Dio();
}
