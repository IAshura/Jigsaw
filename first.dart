import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class FirstLevel extends StatefulWidget {
  const FirstLevel({Key? key}) : super(key: key);

  @override
  State<FirstLevel> createState() => _FirstLevelState();
}

class _FirstLevelState extends State<FirstLevel> {
  TextEditingController _textController = TextEditingController();
  List<int> _numberOrder = List.generate(9, (index) => index + 1);
  List<int> _imageIndexes = [];
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    _generateRandomIndexes();
    player = AudioPlayer();
    _playSoundOnPageEnter();
  }

  void _generateRandomIndexes() {
    final random = Random();
    List<int> indexes = List.generate(9, (index) => index);
    for (int i = indexes.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      int temp = indexes[i];
      indexes[i] = indexes[j];
      indexes[j] = temp;
    }
    setState(() {
      _imageIndexes = indexes;
    });
  }

  void _playSoundOnPageEnter() async {
    // You can change the sound file path based on your actual file structure
    await player.play(AssetSource("backsound/audio_play.mp3"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background/1.jpg"),
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  shrinkWrap: true,
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return LongPressDraggable(
                      data:
                          'assets/images/first/${_imageIndexes[index] + 1}.jpeg',
                      child: Padding(
                        padding: const EdgeInsets.all(0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '${_numberOrder[index]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      feedback: Image.asset(
                        'assets/images/first/${_imageIndexes[index] + 1}.jpeg',
                        width: 115,
                        height: 115,
                        fit: BoxFit.cover,
                      ),
                      childWhenDragging: Container(),
                    );
                  },
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    color: Color.fromARGB(149, 231, 194, 150),
                    height: 150.0,
                    child: Row(
                      children: _imageIndexes.map((index) {
                        return Draggable<String>(
                          data: 'assets/images/first/${index + 1}.jpeg',
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/first/${index + 1}.jpeg',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    color: Colors.black,
                                    child: Text(
                                      '${_numberOrder[index]}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          feedback: Image.asset(
                            'assets/images/first/${index + 1}.jpeg',
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          childWhenDragging: Container(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          filled:
                              true, // Mengaktifkan latar belakang terisi warna
                          fillColor: Color.fromARGB(
                              255, 235, 235, 235), // Warna latar belakang
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _checkText();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(
                            255, 228, 213, 207), // Ubah warna sesuai keinginan
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        fixedSize: Size(115.0, 50.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text('Submit',
                            style: TextStyle(color: Colors.blueGrey)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkText() async {
    String inputText = _textController.text.trim();
    final player = AudioPlayer();
    if (inputText.toLowerCase() == 'borobudur') {
      _showSnackbar('Correct');
      await player.play(AssetSource("backsound/success-1-6297.mp3"));
    } else {
      _showSnackbar('Wrong');
      await player.play(AssetSource("backsound/fail-144746.mp3"));
    }
  }

  @override
  void dispose() {
    // Stop the sound when the user leaves the page
    player.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    Get.snackbar(
      'Result',
      message,
      snackPosition: SnackPosition.TOP,
    );
  }
}
