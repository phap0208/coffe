part of screens;

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key key}) : super(key: key);
  static const String routeName = '/contact_us';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.contact_us.tr()),
      ),
      body: ScreenBody(
        child: Column(
          children: [
            _buildItem(
              LocaleKeys.hotline.tr(),
              AppInformation.hotline,
              Res.ic_phone,
              onTap: () => URLLaucher.openPhoneCall(
                phoneNumber: AppInformation.hotline,
              ),
            ),
            _buildItem(
              LocaleKeys.website.tr(),
              AppInformation.baseURL,
              Res.ic_global,
              onTap: () => URLLaucher.openLink(url: AppInformation.baseURL),
            ),
            _buildItem(
              LocaleKeys.email.tr(),
              AppInformation.email,
              Res.ic_sms,
              onTap: () => URLLaucher.openEmail(
                toEmail: AppInformation.email,
                subject:
                    '${LocaleKeys.hi_text.tr()} ${AppInformation.appName}}',
                body: LocaleKeys.hi_text.tr(),
              ),
            ),
            _buildItem(LocaleKeys.privacy_policy.tr(), LocaleKeys.read.tr(),
                Res.ic_book,
                onTap: () =>
                    URLLaucher.openLink(url: AppInformation.privacyPolicy)),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String subtitle, String imgPath,
      {Function onTap}) {
    return Column(children: [
      InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
          subtitle: Text(subtitle),
          minLeadingWidth: 30.0,
          leading: SvgPicture.asset(
            imgPath,
            color: AppColors.textColor,
            width: 20.0,
            height: 20.0,
            fit: BoxFit.contain,
          ),
          trailing: LineIcon.arrowRight(
            color: AppColors.primaryMediumColor,
          ),
        ),
      ),
      DividerCustom(height: 10),
    ]);
  }
}
