part of widgets;

class VoucherWidget extends StatefulWidget {
  final VoucherModel voucher;
  final bool isUserVoucher;
  final bool enable;
  final Function chooseVoucherPress;
  final bool initChoose;
  const VoucherWidget({
    @required this.voucher,
    @required this.isUserVoucher,
    this.enable = true,
    this.chooseVoucherPress,
    this.initChoose,
    Key key,
  }) : super(key: key);

  @override
  _VoucherWidgetState createState() => _VoucherWidgetState();
}

class _VoucherWidgetState extends State<VoucherWidget> {
  bool isSaved;
  VoucherProvider provider;
  bool _isChoose;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<VoucherProvider>(context, listen: false);
    isSaved = provider.isVoucherSaved(widget.voucher.id);
    _isChoose = widget.initChoose ?? false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  onChangeChoose() {
    setState(() {
      _isChoose = !_isChoose;
    });
    widget.chooseVoucherPress(widget.voucher);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        if (widget.enable) {
          widget.chooseVoucherPress != null
              ? onChangeChoose()
              : showSheet(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Res.voucher_background),
                colorFilter: widget.enable
                    ? null
                    : ColorFilter.mode(Colors.grey[300], BlendMode.srcATop),
                fit: BoxFit.fill)),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                    child: widget.voucher.discountUnit != null
                        ? _buidDefaultVoucher()
                        : Container(
                            height: 80,
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image(
                                image:
                                    base64StringToImage(widget.voucher.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  )),
              Expanded(
                flex: 8,
                child: Stack(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.voucher.title,
                              style: TextStyle(fontSize: 16.0),
                              maxLines: 2,
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                widget.chooseVoucherPress != null
                                    ? InkWell(
                                        onTap: () => showSheet(context),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            LineIcon.angleRight(
                                              size: 13.0,
                                              color: AppColors.darkColor,
                                            ),
                                            Text(
                                              LocaleKeys.rule.tr(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.darkColor),
                                            ),
                                          ],
                                        ))
                                    : Text(
                                        formatDateToString(
                                            widget.voucher.expiryDate),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                if (!widget.isUserVoucher)
                                  _buildSaveButton(isSaved, provider, context)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buidDefaultVoucher() {
    return Container(
      height: 100.0,
      padding: EdgeInsets.all(10.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: widget.enable
                    ? AppColors.primaryColor
                    : AppColors.mutedColor),
            child: Text(
              widget.voucher.applyFor != null
                  ? widget.voucher.displayApplyFor
                  : LocaleKeys.unkown.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.voucher.discountUnit == 'cash'
                    ? '\đ${widget.voucher.discount}'
                    : '${widget.voucher.discount}%',
                style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w600,
                    color: widget.enable
                        ? AppColors.primaryColor
                        : AppColors.mutedColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  InkWell _buildSaveButton(
      bool isSaved, VoucherProvider provider, BuildContext context) {
    return new InkWell(
      onTap: () {
        if (this.isSaved == false) {
          this.setState(() {
            this.isSaved = true;
          });
          Future<bool> success = provider.saveVoucher(this.widget.voucher.id);
          // ignore: unrelated_type_equality_checks
          if (success == false) {
            showToast(LocaleKeys.save_voucher_fail.tr());
            this.setState(() {
              this.isSaved = false;
            });
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: isSaved ? Colors.grey : AppColors.darkColor),
        child: Text(
          LocaleKeys.save.tr(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future showSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => openBottomSheet(
            context: context, child: VoucherDetail(voucher: widget.voucher)));
  }
}

class CardItem extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onPressed;
  const CardItem({@required this.text,this.onPressed,this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.primaryLightColor,
      onTap: onPressed,
      child: Container(
        width: SizeConfig.screenWidth * 0.43,
        height: SizeConfig.screenHeigh * 0.10,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(5, 5),
                  blurRadius: 6.0,
                  spreadRadius: 3.0),
            ],
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.primaryLightColor),
                child: SvgPicture.asset('assets/icons/$icon'),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
