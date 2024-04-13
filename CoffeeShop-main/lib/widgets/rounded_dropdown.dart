part of widgets;

class RoundedDropDown extends StatelessWidget {
  const RoundedDropDown(
      {this.validator,
      this.onChanged,
      this.label,
      @required this.value,
      @required this.listItem,
      @required this.listItemDisplay});
  final Function(dynamic) validator;
  final dynamic value;
  final Function(dynamic) onChanged;
  final List listItem;
  final List listItemDisplay;
  final String label;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        decoration: InputDecoration(
            labelText: label ?? '',
            labelStyle: TextStyle(
                color: AppColors.textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.textColor),
                borderRadius: BorderRadius.circular(50.0)),
            contentPadding: EdgeInsets.only(left: 20.0, right: 10.0)),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        value: value,
        dropdownColor: Colors.white,
        focusColor: AppColors.primaryColor,
        icon: LineIcon.chevronCircleDown(),
        hint: Text(LocaleKeys.select_gender.tr()),
        style: TextStyle(color: AppColors.textColor),
        onChanged: onChanged,
        items: List.generate(
            listItem.length,
            (index) => DropdownMenuItem(
                value: listItem[index],
                child: Text(listItemDisplay[index].toString().capitalize()))));
  }
}
