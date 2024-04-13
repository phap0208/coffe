part of screens;

class AccumulateInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).getUser;
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(5, 5),
                blurRadius: 6.0,
                spreadRadius: 3.0),
          ]),
      child: Column(
        children: [
          Column(
            children: [
              if (user.barCode != null)
                SvgPicture.string(
                  user.barCode,
                  width: SizeConfig.screenWidth * 0.5,
                  fit: BoxFit.fitWidth,
                ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0)),
                    gradient: AppColors.primaryGradientColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${user.displayName}',
                          style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.eco_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              userProvider.getLevelString(),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.current_point.tr(),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text('${user.point} ${LocaleKeys.point.tr()}',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.total_point.tr(),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text('${user.totalPoint} ${LocaleKeys.point.tr()}',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 10.0,
                    margin: const EdgeInsets.only(left: 25.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        gradient: AppColors.primaryGradientColor),
                  ),
                  Positioned(
                      top: -10.0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.primaryColor, width: 3),
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          Icons.eco_outlined,
                          size: 30.0,
                          color: AppColors.primaryColor,
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${userProvider.getLevelString()}',
                    style: TextStyle(
                        color: AppColors.primaryColor, fontSize: 16.0),
                  ),
                  Text(
                    '${userProvider.getLevelString(isNext: true)}',
                    style: TextStyle(
                        color: AppColors.primaryColor, fontSize: 16.0),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(LocaleKeys.point_left
                  .tr(args: [userProvider.caculateNextLevel().toString()])),
              Text(LocaleKeys.redeem_not_affect.tr())
            ],
          )
        ],
      ),
    );
  }
}
