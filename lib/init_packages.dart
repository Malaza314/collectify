import 'package:cloud_functions/cloud_functions.dart';
import 'package:collectify/controllers/app_controller.dart';
import 'package:collectify/controllers/auth_controller.dart';

final functions = FirebaseFunctions.instance;
final appController = AppController.instance;
final authController = AuthController.instance;