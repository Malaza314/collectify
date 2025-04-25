 import 'package:get/get.dart';

class AppController extends GetxController{
  static final AppController instance = Get.find();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setIsLoading(bool value) {
    // Updates the loading state
    _isLoading.value = value;
    }

  // signup password textfield
  final RxBool _obscureSignUpPassword = false.obs;
  void setObscureSignUpPassword() => _obscureSignUpPassword.value = !_obscureSignUpPassword.value;
  bool get obscureSignUpPassword => _obscureSignUpPassword.value;

  // confirm signup password textfield
  final RxBool _obscureConfirmSignUpPassword = false.obs;
  void setObscureConfirmSignUpPassword() => _obscureConfirmSignUpPassword.value = !_obscureConfirmSignUpPassword.value;
  bool get obscureConfirmSignUpPassword => _obscureConfirmSignUpPassword.value;

  // signup password textfield
  final RxBool _obscureLoginPassword = false.obs;
  void setobscureLoginPassword() => _obscureLoginPassword.value = !_obscureLoginPassword.value;
  bool get obscureLoginPassword => _obscureLoginPassword.value;


  // upload id base64
  final _uploadIdBase64 = RxString("");
  String get uploadIdBase64 => _uploadIdBase64.value;
  void setUploadIdBase64({required String value}) {
    // Updates the upload id base64
    _uploadIdBase64.value = value;
  }

  //upload LendingLicense base64
  final _uploadLendingLicenseBase64 = RxString("");
  String get uploadLendingLicenseBase64 => _uploadLendingLicenseBase64.value;
  void setUploadLendingLicenseBase64({required String value}) {
    // Updates the upload LendingLicense base64
    _uploadLendingLicenseBase64.value = value;
  }


  // - - - - - - customers - - - - - - - 
  final _allCustomers = RxList<dynamic>([]);
  List<dynamic> get allCustomers => _allCustomers.value;
  void setAllCustomers({required List<dynamic> value}) {
    // Updates the all customers
    _allCustomers.value = value;
  }

  // - - - - - - users - - - - - - - 
  final _allUsers = RxList<dynamic>([]);
  List<dynamic> get allUsers => _allUsers.value;
  void setAllUsers({required List<dynamic> value}) {
    // Updates the all users
    _allUsers.value = value;
  }
  



}