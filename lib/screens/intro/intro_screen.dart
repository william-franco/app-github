import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = List();

  final titleStyle = TextStyle(color: Color(0xFF000000), fontSize: 30.0);
  final subTitleStyle = TextStyle(color: Color(0xFF000000), fontSize: 20.0);
  final customWhite = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "App GitHub",
        styleTitle: titleStyle,
        description: "Conheça os repositórios.",
        styleDescription: subTitleStyle,
        pathImage: "assets/logo/github-title-1.png",
        backgroundColor: customWhite,
      ),
    );
    slides.add(
      Slide(
        title: "App GitHub",
        styleTitle: titleStyle,
        description: "Busque projetos para estudar.",
        styleDescription: subTitleStyle,
        pathImage: "assets/logo/octocat-1.png",
        backgroundColor: customWhite,
      ),
    );
    slides.add(
      Slide(
        title: "App GitHub",
        styleTitle: titleStyle,
        description: "Contribua para a comunidade.",
        styleDescription: subTitleStyle,
        pathImage: "assets/logo/github-title-1.png",
        backgroundColor: customWhite,
      ),
    );
  }

  void onDonePress() {
    Get.offNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      // Next button
      nameNextBtn: "Próximo",
      // Done button
      onDonePress: this.onDonePress,
      nameDoneBtn: "Começar",
      styleNameDoneBtn: TextStyle(color: Color(0xFF000000)),
      // Skip button
      nameSkipBtn: "Pular",
      styleNameSkipBtn: TextStyle(color: Color(0xFF000000)),
      // Prev button
      namePrevBtn: "Anterior",
      styleNamePrevBtn: TextStyle(color: Color(0xFF000000)),
    );
  }
}
