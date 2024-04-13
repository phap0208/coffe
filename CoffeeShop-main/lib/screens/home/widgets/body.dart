part of screens;

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    var newList = provider.newProducts(limit: 10);
    var saleList = provider.saleProducts(limit: 10);
    return ListView(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: SizedBox(
            height: 200.0,
            width: double.infinity,
            child: HomeCarousel(),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeadingUnderline(text: LocaleKeys.new_text.tr()),
            SeeAllButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SeeProductScreen(
                          data: provider.newProducts(limit: 20),
                        )));
              },
            )
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(newList.length,
                  (index) => ProductWidget(product: newList[index]))),
        ),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeadingUnderline(text: LocaleKeys.sale.tr()),
            SeeAllButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SeeProductScreen(
                          data: provider.saleProducts(),
                        )));
              },
            )
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(saleList.length,
                  (index) => ProductWidget(product: saleList[index]))),
        ),
      ],
    );
  }
}
