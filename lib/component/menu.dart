import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revver/component/spacer.dart';
import 'package:revver/controller/test.dart';
import 'package:revver/globals.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              detailMenu(
                  context, "assets/svg/clipboard-solid 1.svg", "Note", "/"),
              detailMenu(
                  context, "assets/svg/book-solid.svg", "E-Learning", "/"),
              detailMenu(
                  context, "assets/svg/paper-plane-solid.svg", "Plan", "/"),
              detailMenu(
                  context, "assets/svg/stethoscope-solid.svg", "E-Health", "/"),
            ],
          ),
          SpacerHeight(h: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              detailMenu(context, "assets/svg/trophy-solid.svg", "Goals", "/"),
              detailMenu(
                  context, "assets/svg/people-group-solid.svg", "Support", "/"),
              detailMenu(
                  context, "assets/svg/chart-pie-solid.svg", "Report", "/"),
              detailMenu(
                  context, "assets/svg/chart-pie-solid.svg", "Revver", "/"),
            ],
          ),
        ],
      ),
    );
  }

  detailMenu(BuildContext context, String image, String title, String goTo) {
    return GestureDetector(
      onTap: () {
        // GoRouter.of(context).go(goTo);
        test(context);
      },
      child: Column(
        children: [
          SvgPicture.asset(image, height: 30),
          SpacerHeight(h: 5),
          Text(
            title,
            style: CustomFont.regular12,
          ),
        ],
      ),
    );
  }
}