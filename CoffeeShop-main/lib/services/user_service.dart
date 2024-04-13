part of services;

//checkphone
Future<bool> isPhoneExisted(String phone) async {
  bool isExisted;
  final response = await http.post(Uri.parse(checkPhone),
      headers: {'Accept': 'application/json'}, body: {'phone': phone});

  print(response.statusCode);
  switch (response.statusCode) {
    case 200:
      isExisted = true;
      break;
    case 403:
      isExisted = false;
      break;
  }
  return isExisted;
}

//Login
Future<ApiResponse> loginPhone(String phone, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'phone': phone, 'password': password, 'method': 'phone'});
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = UserModel.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//Login
Future<ApiResponse> loginEmail(String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'method': 'email'});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = UserModel.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//Register
Future<ApiResponse> register(
    {String phone,
    String email,
    String password,
    String displayName,
    DateTime birthday}) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'display_name': displayName,
      'phone': phone,
      'email': email,
      'birthday': birthday.toString(),
      'password': password
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = UserModel.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//Get user information
Future<ApiResponse> getUserInformation() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = UserModel.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> updateUserRequest(
    {String email,
    String password,
    String displayName,
    String image,
    String gender}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('$userURL/edit'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'display_name': displayName,
      'email': email,
      'gender': gender,
      'image': image
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> changePasswordRequest(
    {String oldPwd, String newPwd}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(userChangePassword), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'old_password': oldPwd,
      'new_password': newPwd,
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;

      default:
        apiResponse.error =
            jsonDecode(response.body)['message'] ?? somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//crate address
Future<ApiResponse> createAddressRequest({AddressModel address}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    print(address.toJson());
    String token = await getToken();
    final response = await http.post(Uri.parse('$addressesURL/create'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'content-type': 'application/json'
        },
        body: json.encode(address.toJson()));
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['address']['id'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//update address
Future<ApiResponse> updateAddressRequest({AddressModel address, int id}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$addressesURL/$id/edit'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'content-type': 'application/json'
        },
        body: jsonEncode({
          'title': address.title,
          'address': address.address,
          'receiver_name': address.receiverName,
          'receiver_phone': address.receiverPhone,
          'description': address.description,
          'coordinates': address.coordinates,
        }));
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//delete user address
Future<ApiResponse> deleteAddressRequest(int id) async {
  ApiResponse apiResponse = ApiResponse();
  print('$addressesURL/$id/delete');
  try {
    String token = await getToken();
    final response =
        await http.delete(Uri.parse('$addressesURL/$id/delete'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {}
  return apiResponse;
}

//Get user addresses
Future<ApiResponse> getUserAddresses() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$addressesURL'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['addresses']
            .map((a) => AddressModel.fromJson(a))
            .toList();
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print('error address');
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> sendMailReset({String phone}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response =
        await http.post(Uri.parse('$baseURL/password/create'), headers: {
      'Accept': 'application/json',
    }, body: {
      'phone': phone
    });
    apiResponse.data = jsonDecode(response.body)['message'];
  } catch (e) {
    print(e);
  }
  return apiResponse;
}

//Get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

//Get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('id') ?? 0;
}

//Logout
Future<void> logout(BuildContext context) async {
  //reset all data
  final voucherProvider = Provider.of<VoucherProvider>(context, listen: false);
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final categoryProvider =
      Provider.of<CategoryProvider>(context, listen: false);
  final productProvider = Provider.of<ProductProvider>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final firebaseProvider =
      Provider.of<FirebaseProvider>(context, listen: false);
  final navigationProvider =
      Provider.of<NavigationProvider>(context, listen: false);
  SharedPreferences pref = await SharedPreferences.getInstance();

  //voucher
  voucherProvider.setUserVouchers([]);
  voucherProvider.setVouchers([]);
  voucherProvider.setRewards([]);
  voucherProvider.setLoading(true);
  //cart
  cartProvider.clear();
  //category
  categoryProvider.setCategoryList([]);
  //product
  productProvider.setLoading(true);
  productProvider.setProductList([]);
  //user

  authProvider.setAddressLoading(true);
  authProvider.setAddresses([]);
  //share pref
  bool loginGoogle = pref.getBool(PrefKey.GOOGLE_SIGN_IN);
  bool loginFacebook = pref.getBool(PrefKey.FACEBOOK_SIGN_IN);
  if (loginGoogle == true) {
    firebaseProvider.googleLogOut();
    pref.setBool(PrefKey.GOOGLE_SIGN_IN, false);
  }
  if (loginFacebook == true) {
    firebaseProvider.facebookLogOut();
    pref.setBool(PrefKey.FACEBOOK_SIGN_IN, false);
  }
  return await pref.remove('token').then((value) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false);
    authProvider.setUser(UserModel());
    navigationProvider.clear();
  });
}
