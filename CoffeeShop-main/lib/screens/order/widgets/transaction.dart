part of screens;

class Transaction extends StatelessWidget {
  const Transaction({this.model});
  final TransactionModel model;
  Widget getIcon() {
    Map statusList = {
      'pending': Res.ic_truck_time,
      'cancelled': Res.ic_truck_remove,
      'packing': Res.ic_3d_box,
      'shipping': Res.ic_truck_run,
      'success': Res.ic_truck_tick
    };
    for (final item in statusList.entries) {
      if (item.key == model.status) {
        return SvgPicture.asset(
          item.value,
          height: getHeight(15.0),
          width: getWidth(15.0),
          color: AppColors.blackColor,
        );
      }
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetail(
                      model: model,
                    )));
      },
      child: RoundedContainer(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${model.code}',
                  style: TextStyle(
                      fontSize: AppStyles.textSize15,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '${formatDateToStringWithTime(model.createdAt)}',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.blackColor.withOpacity(0.6)),
                ),
              ],
            ),
            SizedBox(
              height: getHeight(10.0),
            ),
            Text(
              '${model.order.address.address}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: getHeight(10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${convertVND(double.parse(model.order.grandtotal))}',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppStyles.textSize14),
                ),
                Row(
                  children: [
                    Text(
                      '${model.status.tr()}'.capitalize(),
                      style: TextStyle(
                          fontSize: AppStyles.textSize14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: getWidth(5.0)),
                    getIcon(),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
