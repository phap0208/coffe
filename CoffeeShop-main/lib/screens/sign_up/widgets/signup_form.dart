part of screens;

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtPhone = TextEditingController();
  TextEditingController _txtDisplayName = TextEditingController();
  TextEditingController _txtBirthday = TextEditingController();
  List<String> listGender = [
    'male',
    'female',
    'other',
  ];
  List<String> listGenderData = [
    LocaleKeys.gender_male.tr(),
    LocaleKeys.gender_female.tr(),
    LocaleKeys.gender_other.tr(),
  ];
  String _dropdownGender;
  bool _isSocialSignup = false;

  @override
  void dispose() {
    _txtEmail.dispose();
    _txtPhone.dispose();
    _txtDisplayName.dispose();
    _txtBirthday.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final provider = Provider.of<FirebaseProvider>(context, listen: false);
    if (provider.user != null) {
      _txtEmail.text = provider.user.email;
      _txtDisplayName.text = provider.user.displayName;
      _isSocialSignup = true;
    }
    super.initState();
  }

  submitForm() async {
    hideKeyboard(context);
    final naviProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    if (_formKey.currentState.validate()) {
      naviProvider.setLoading(true);
      bool phoneCheck = await isPhoneExisted(_txtPhone.text.trim());
      if (phoneCheck == null) return;
      if (!phoneCheck) {
        final UserModel instance = UserModel(
            displayName: _txtDisplayName.text.trim(),
            birthday: formatStringToDate(_txtBirthday.text),
            gender: _dropdownGender,
            phone: _txtPhone.text.trim(),
            email: _txtEmail.text.trim());

        Navigator.of(context)
            .pushNamed(OTPScreen.routeName, arguments: instance);
      } else {
        showDialog(
            context: context,
            builder: (context) => PopUpNotify(
                  title: LocaleKeys.opps.tr(),
                  content: Text(LocaleKeys.phone_taken.tr()),
                ));
      }
      naviProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoundedTextField(
                controller: _txtDisplayName,
                validator: (value) => Validate.displayNameValidate(value),
                hintText: LocaleKeys.display_name.tr(),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15.0),
              RoundedTextField(
                controller: _txtEmail,
                validator: (value) => Validate.emailValidate(value),
                hintText: 'Email',
                readOnly: _isSocialSignup,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15.0),
              RoundedTextField(
                controller: _txtPhone,
                hintText: LocaleKeys.phone.tr(),
                validator: (value) => Validate.phoneValidate(value),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 15.0),
              RoundedTextField(
                controller: _txtBirthday,
                validator: (value) => Validate.notEmptyValidate(value),
                keyboardType: TextInputType.datetime,
                readOnly: true,
                isDate: true,
                hintText: LocaleKeys.birthday.tr(),
              ),
              SizedBox(height: 15.0),
              RoundedDropDown(
                  value: _dropdownGender,
                  listItem: listGender,
                  listItemDisplay: listGenderData,
                  validator: (value) => Validate.notEmptyValidate(value),
                  onChanged: (value) {
                    setState(() {
                      _dropdownGender = value;
                    });
                  }),
              SizedBox(
                height: getHeight(50.0),
              ),
              RoundedButton(
                onPressed: submitForm,
                title: LocaleKeys.continue_text.tr(),
                color: AppColors.primaryColor,
              )
            ],
          ),
        ));
  }
}
