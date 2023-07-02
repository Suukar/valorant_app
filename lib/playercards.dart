import 'package:flutter/material.dart';
import 'package:valorant_app/homepage.dart';
import 'package:valorant_app/widgets/cardff.dart';
import 'package:valorant_app/widgets/custom_app_bar.dart';
import 'package:valorant_app/widgets/custom_drawer.dart';
import 'constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int currentIndex = 0;

class CardData {
  final String displayName;
  final String largeArt;

  CardData({required this.displayName, required this.largeArt});
}

class PlayerCardsScreen extends StatefulWidget {
  const PlayerCardsScreen({super.key});

  @override
  State<PlayerCardsScreen> createState() => PlayerCardsState();
}

class PlayerCardsState extends State<PlayerCardsScreen> {
  List<CardData> playerData = [];
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const url =
        'https://valorant-api.com/v1/playercards'; // Replace with your API endpoint
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final cardss = data['data'];

      setState(() {
        playerData = cardss
            .map<CardData>((playercard) => CardData(
                  displayName: playercard['displayName'],
                  largeArt: playercard['largeArt'],
                ))
            .toList();
      });
    }
  }

  void goToPrevious() {
    carouselController.previousPage();
  }

  void goToNext() {
    carouselController.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundcolor,
      appBar: const CustomAppBar(),
      drawer: const CustomAppDrawer(),
      body: Column(
        children: [
          const Text(
            'Valorant playercards',
            style: TextStyle(fontSize: 25),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Homepage(),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/valorantlogo.png',
                height: 200,
                width: 200,
              ),
            ),
          ),
          playerData.isNotEmpty
              ? CarouselSlider.builder(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    height: 455,

                    // Adjust the height as needed
                    enableInfiniteScroll: true,
                    // Set to false if you don't want infinite scrolling
                    enlargeCenterPage: false,
                    // Set to false if you don't want the center image to be larger
                    // Set to false if you don't want auto-play
                    autoPlayInterval: const Duration(seconds: 2),
                    // Adjust the interval duration
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    // Adjust the animation duration
                    autoPlayCurve: Curves.fastOutSlowIn,
                    // Adjust the animation curve
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                  itemCount: playerData.length,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    final playercard = playerData[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            playercard.displayName,
                            style: const TextStyle(
                              color: kMenucolor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Expanded(
                            child: Cardff(
                              imagePath: playercard.largeArt,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          const Spacer(),
          buildBottom(currentIndex, playerData.length),
        ],
      ),
    );
  }

  SizedBox buildBottom(int currentIndex, int maxLength) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
            ),
            color: Colors.white,
            onPressed: goToPrevious,
          ),
          Text(
            '${currentIndex + 1}/$maxLength',
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.arrow_forward,
              size: 20,
            ),
            onPressed: goToNext,
          ),
        ],
      ),
    );
  }
}
