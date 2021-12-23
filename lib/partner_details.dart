import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:partner_details/partner.dart';
import 'package:partner_details/rating_star_field.dart';
import 'package:partner_details/size_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PartnerDetails extends StatefulWidget {
  final Partner partner;
  const PartnerDetails({Key? key, required this.partner}) : super(key: key);

  @override
  _PartnerDetailsState createState() => _PartnerDetailsState();
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}

class _PartnerDetailsState extends State<PartnerDetails>
    with TickerProviderStateMixin {
  var top = 0.0;
  var isDrawingLayout = true;
  var _controller = ScrollController();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        isDrawingLayout = false;
      });
    });
    _controller.addListener(() {
      setState(() {});
    });
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    SizeProvider().init(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: CustomScrollView(
        controller: _controller,
        scrollBehavior: CustomScrollBehavior().copyWith(scrollbars: false),
        slivers: [
          SliverAppBar(
            expandedHeight: getProportionalHeight(750),
            centerTitle: true,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                top = constraints.biggest.height;
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: top >= getProportionalHeight(750) && !isDrawingLayout
                      ? Column(
                          children: [
                            SizedBox(
                              height: getProportionalHeight(210),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                              ),
                              width: double.infinity,
                              height: getProportionalHeight(540),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: getProportionalHeight(42),
                                      ),
                                      SizedBox(
                                        height: getProportionalHeight(350),
                                        child: Image.network(
                                          widget.partner.profilePictureUrl,
                                        ),
                                      ),
                                      Text(
                                        widget.partner.name,
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalHeight(40)),
                                      ),
                                      Text(
                                        widget.partner.phoneNumber.toString(),
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalHeight(28)),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: getProportionalHeight(120),
                                      ),
                                      AnimatedProgressBar(
                                        width: getProportionalHeight(220),
                                        progress: widget.partner.rating,
                                      ),
                                      SizedBox(
                                        height: getProportionalHeight(30),
                                      ),
                                      Text(
                                        "Total Orders - ${widget.partner.totalRatings}",
                                        style: TextStyle(
                                            fontSize:
                                                getProportionalHeight(28)),
                                      ),
                                      SizedBox(
                                        height: getProportionalHeight(30),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(Icons.location_on_rounded,
                                              color: Colors.grey.shade500),
                                          Text(widget.partner.city),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                );
              },
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: top <= getProportionalHeight(650) && !isDrawingLayout
                      ? Container(
                          margin:
                              EdgeInsets.only(left: getProportionalWidth(54)),
                          child: Image.network(
                            widget.partner.profilePictureUrl,
                            width: getProportionalWidth(140),
                          ),
                        )
                      : SizedBox(
                          width: getProportionalWidth(194),
                          child: Icon(
                            Icons.arrow_back_rounded,
                          ),
                        ),
                ),
                SizedBox(
                  width: getProportionalWidth(54),
                ),
                Text(
                  "Partner Details",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            titleSpacing: 0,
            toolbarHeight: getProportionalHeight(210),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFEFEFE),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    getProportionalHeight(54),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    height: getProportionalHeight(64),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.partner.job),
                        VerticalDivider(),
                        Text("₹ ${widget.partner.rate}")
                      ],
                    ),
                  ),
                  TabBar(
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 2),
                        insets: EdgeInsets.symmetric(
                            horizontal: getProportionalWidth(80))),
                    unselectedLabelColor: Colors.grey.shade400,
                    labelStyle: TextStyle(fontFamily: "Poppins"),
                    labelColor: Colors.black,
                    tabs: const [
                      Tab(
                        text: "Catalogue",
                      ),
                      Tab(
                        text: "Reviews",
                      )
                    ],
                    controller: _tabController,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView(
                            children: getPartnerDetailsCards(
                                widget.partner.partners)),
                        ListView(
                          children:
                              getRatingDetailsCards(widget.partner.reviews),
                        ),
                      ],
                      controller: _tabController,
                    ),
                  )
                ],
              ),
              height: 800,
            ),
          )
        ],
      ),
    );
  }
}

List<Widget> getPartnerDetailsCards(List<PartnerCatalogue> partners) {
  List<Widget> children = [];
  for (var partner in partners) {
    children.add(
      CustomListTile(
        trailing: "₹ ${partner.rate}",
        leadingUrl: partner.profilePicture,
        onTouch: () {},
        title: partner.name,
        subtitle: partner.description,
      ),
    );
  }
  return children;
}

List<Widget> getRatingDetailsCards(List<PartnerReview> ratings) {
  List<Widget> children = [];
  for (var rating in ratings) {
    children.add(
      CustomListTile(
        trailing: rating.date,
        isPrice: false,
        title: rating.name,
        leadingUrl: rating.profilePicture,
        onTouch: () {},
        rating: RatingStarField(
          filledState: rating.rating,
        ),
        subtitle: rating.reviewDescription,
      ),
    );
  }
  return children;
}

class CustomListTile extends StatefulWidget {
  final String trailing;
  final String leadingUrl;
  final String? title;
  final String subtitle;
  final Function() onTouch;
  final Widget rating;
  final bool isPrice;
  const CustomListTile(
      {Key? key,
      required this.leadingUrl,
      this.subtitle = "",
      this.title,
      this.rating = const SizedBox(),
      this.trailing = "",
      this.isPrice = true,
      required this.onTouch})
      : super(key: key);

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionalWidth(60),
          vertical: getProportionalHeight(28)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTouch,
        child: Container(
          padding: EdgeInsets.all(getProportionalWidth(40)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              getProportionalHeight(54),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: getProportionalHeight(16),
                  spreadRadius: 0.01,
                  color:
                      (Theme.of(context).cardTheme.shadowColor ?? Colors.grey)
                          .withOpacity(0.5))
            ],
          ),
          child: Row(
            children: [
              widget.isPrice
                  ? ClipRRect(
                      child: Image.network(
                        widget.leadingUrl,
                        height: getProportionalHeight(210),
                        width: getProportionalHeight(210),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          BorderRadius.circular(getProportionalHeight(32)),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            widget.leadingUrl,
                            height: getProportionalHeight(180),
                            width: getProportionalHeight(180),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: getProportionalHeight(20),
                        ),
                        Text(
                          widget.title!,
                          style: TextStyle(fontSize: getProportionalHeight(32)),
                        )
                      ],
                    ),
              SizedBox(
                width: getProportionalWidth(70),
              ),
              Expanded(
                child: Container(
                  height: getProportionalHeight(210),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.isPrice
                              ? Text(
                                  widget.title!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : widget.rating,
                          Text(
                            widget.trailing,
                            style: TextStyle(
                                fontWeight: widget.isPrice
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: getProportionalHeight(
                                    widget.isPrice ? 50 : 32),
                                color: widget.isPrice
                                    ? Colors.black
                                    : Colors.grey),
                          )
                        ],
                      ),
                      Text(
                        widget.subtitle,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: getProportionalHeight(40),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedProgressBar extends StatefulWidget {
  final double width;
  final double height;
  final double progress;
  const AnimatedProgressBar(
      {Key? key, this.width = 100, this.height = 100, this.progress = 0.0})
      : super(key: key);

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              blurRadius: 56,
              spreadRadius: -10,
              color: Theme.of(context).shadowColor.withOpacity(0.4))
        ]),
        child: AspectRatio(
            aspectRatio: 1,
            child: SfRadialGauge(
              animationDuration: 2000,
              axes: [
                RadialAxis(
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        positionFactor: 0.5,
                        angle: 90,
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.progress.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xFF4cdc22),
                              size: 15,
                            ),
                          ],
                        ))
                  ],
                  minimum: 0,
                  maximum: 5,
                  showLabels: false,
                  showTicks: false,
                  startAngle: 270,
                  endAngle: 270,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 1,
                    color: Colors.white,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: widget.progress,
                      width: 0.15,
                      color: const Color(0xFF4cdc22),
                      enableAnimation: true,
                      pointerOffset: 0,
                      cornerStyle: CornerStyle.bothCurve,
                      sizeUnit: GaugeSizeUnit.factor,
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
