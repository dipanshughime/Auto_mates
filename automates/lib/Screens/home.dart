import 'package:automates/Screens/Profile.dart';
import 'package:automates/Screens/login.dart';
import 'package:automates/Screens/myCompletedReq.dart';
import 'package:automates/Screens/myOngingReq.dart';
import 'package:automates/Screens/otherOngingReq.dart';
import 'package:automates/Screens/register.dart';
import 'package:automates/utils/colors.dart';
import 'package:flutter/material.dart';

class MyOrdersSender extends StatefulWidget {
  const MyOrdersSender({super.key});

  @override
  State<MyOrdersSender> createState() => _MyOrderSender_State();
}

class _MyOrderSender_State extends State<MyOrdersSender>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    DateTime timestamp = DateTime.now();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // orders from location wala container
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(color: AppColors.header),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("User name",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            )),
                        GestureDetector(
                          onTap: () {
                            // Navigate to another page when the image is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfilePage()), // Replace 'AnotherPage()' with the page you want to navigate to
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //tabbar
            Container(
              child: TabBar(
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                unselectedLabelColor: AppColors.grey,
                labelColor: AppColors.primary,
                tabs: const [
                  Tab(
                    text: 'On Going Request',
                  ),
                  Tab(
                    text: 'My OnGoing request',
                  ),
                  Tab(
                    text: 'My complete request',
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      OtherOngoingReq(),
                      MyOngoingReq(),
                      MyCompleteReq()

                      // OngoingTab(),
                      // DeliveredTab(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
