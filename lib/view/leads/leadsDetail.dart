import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revver/globals.dart';
import 'package:revver/view/leads/leadsDetailForm.dart';
import 'package:revver/view/leads/leadsDetailMeeting.dart';

class LeadsDetail extends StatefulWidget {
  const LeadsDetail({Key key}) : super(key: key);

  @override
  State<LeadsDetail> createState() => _LeadsDetailState();
}

class _LeadsDetailState extends State<LeadsDetail> {
  final List<Widget> _children = [
    LeadsDetailForm(x: "x"),
    LeadsDetailMeeting(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.whiteColor,
          elevation: 0,
          title: Text("Leads Detail", style: CustomFont.tabbarHeading),
          leading: CupertinoNavigationBarBackButton(
              color: CustomColor.blackColor,
              onPressed: () => GoRouter.of(context).pop()),
          bottom: PreferredSize(
            preferredSize: Size(0, 50),
            child: Container(
              color: CustomColor.goldColor,
              child: TabBar(
                indicatorColor: CustomColor.blackColor,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    text: "Detail",
                  ),
                  Tab(
                    text: "Meeting",
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: _children,
        ),
      ),
    );
  }
}