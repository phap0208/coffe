part of screens;
class VoucherDetail extends StatelessWidget {
  final VoucherModel voucher;
  VoucherDetail({this.voucher});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            AppInformation.appName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            voucher.title ?? 'null',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          Divider(height: 20.0),
          if (voucher.qrCode != null)
            Image(
              image: base64StringToImage(voucher.qrCode),
              height: SizeConfig.screenWidth * 0.8,
              width: SizeConfig.screenWidth * 0.8,
            ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                voucher.couponCode,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.0, color: Colors.grey[700]),
              ),
              TextButton(
                  onPressed: () {
                    coppyClipBoard(voucher.couponCode, context);
                  },
                  child: Text(
                    LocaleKeys.copy.tr(),
                    style: TextStyle(fontSize: 18.0),
                  )),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          if (voucher.discount != null) _buildOrderButton(context),
          SizedBox(height: 15.0),
          Divider(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.expired_date.tr(),
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              Text(formatDateToString(voucher.expiryDate) ?? 'null',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]))
            ],
          ),
          Divider(
            height: 20.0,
          ),
          Text(
            voucher.content ?? LocaleKeys.no_content.tr(),
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Align _buildOrderButton(BuildContext context) {
    return Align(
      child: ElevatedButton(
        child: Text(LocaleKeys.order_now.tr()),
        onPressed: () {
          Navigator.of(context).pop();
          Provider.of<NavigationProvider>(context, listen: false)
              .redirectScreen(ProductScreen());
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            primary: AppColors.primaryMediumColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: TextStyle(fontSize: 16.0)),
      ),
    );
  }
}
