import 'package:automates/Screens/Profile.dart';
import 'package:automates/Screens/login.dart';
import 'package:automates/Screens/myCompletedReq.dart';
import 'package:automates/Screens/myOngingReq.dart';
import 'package:automates/Screens/otherOngingReq.dart';
import 'package:automates/Screens/register.dart';
import 'package:automates/Screens/weather.dart';
import 'package:automates/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather {
  final double temperature;
  final String description;

  Weather({required this.temperature, required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['main'],
    );
  }
}

class MyOrdersSender extends StatefulWidget {
  const MyOrdersSender({super.key});

  @override
  State<MyOrdersSender> createState() => _MyOrderSender_State();
}

class _MyOrderSender_State extends State<MyOrdersSender>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Weather _weather;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    //  _fetchWeather();
  }

  @override
  void dispose() {
    DateTime timestamp = DateTime.now();

    super.dispose();
  }

  Future<void> _fetchWeather() async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=London&appid=4172e82b25bf2dff4705ae86499f6881'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _weather = Weather.fromJson(data);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/auto.gif'), // Replace with your image path
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   "User name",
                            //   textAlign: TextAlign.left,
                            //   style: TextStyle(
                            //     fontSize: 30,
                            //     fontWeight: FontWeight.w800,
                            //     color: AppColors.black,
                            //   ),
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => const WeatherScreen(),
                            //       ),
                            //     );
                            //   },
                            //   child: Text(
                            //     "Check Weather",
                            //     textAlign: TextAlign.left,
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.w800,
                            //       color: AppColors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeatherScreen(),
                          ),
                        );
                        // Handle button press
                      },
                      child:
                          Icon(Icons.cloud), // Replace with your weather icon
                      backgroundColor:
                          Colors.blue, // Set button background color
                    ),
                  ),
                ],
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
