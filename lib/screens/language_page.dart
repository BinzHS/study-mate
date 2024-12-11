import 'package:flutter/material.dart';
import 'lessons/language1/lesson1_page.dart';
import 'lessons/language1/lesson2_page.dart';
import 'lessons/language1/lesson3_page.dart';
import 'lessons/language1/lesson4_page.dart';
import 'lessons/language1/lesson5_page.dart';
import 'lessons/language2/lesson1_page.dart';
import 'lessons/language2/lesson2_page.dart';
import 'lessons/language2/lesson3_page.dart';
import 'lessons/language2/lesson4_page.dart';
import 'lessons/language2/lesson5_page.dart';
import 'lessons/language3/lesson1_page.dart';
import 'lessons/language3/lesson2_page.dart';
import 'lessons/language3/lesson3_page.dart';
import 'lessons/language3/lesson4_page.dart';
import 'lessons/language3/lesson5_page.dart';

class LanguagePage extends StatefulWidget {
  final String language;

  LanguagePage({Key? key, required this.language}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _buttonAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Adjust delay for each button's animation
    _buttonAnimations = List.generate(5, (index) {
      return Tween<Offset>(
        begin: Offset(-1.0, 0), // Start from the left
        end: Offset.zero, // End at the normal position
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1, // Add delay for each button (0.2s interval for each)
            0.5,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    // Start the animation
    _animationController.forward();
  }

  // Subject-specific lesson names
  final Map<String, List<String>> lessonNames = {
    'Language1': ['General Chemistry', 'Inorganic', 'Organic', 'Physical Chemistry', 'Calculations'],
    'Language2': ['Mechanics', 'Kinematics', 'Dynamics', 'Optics', 'Thermodynamics'],
    'Language3': ['Algebra', 'Calculus', 'Geometry', 'Probability', 'Statistics'],
  };

  void navigateToLesson(BuildContext context, int lessonIndex) {
    Widget page;

    if (widget.language == 'Language1') {
      switch (lessonIndex) {
        case 1:
          page = Language1Lesson1Page();
          break;
        case 2:
          page = Language1Lesson2Page();
          break;
        case 3:
          page = Language1Lesson3Page();
          break;
        case 4:
          page = Language1Lesson4Page();
          break;
        case 5:
          page = Language1Lesson5Page();
          break;
        default:
          page = Center(child: Text('Lesson not found'));
      }
    } else if (widget.language == 'Language2') {
      switch (lessonIndex) {
        case 1:
          page = Language2Lesson1Page();
          break;
        case 2:
          page = Language2Lesson2Page();
          break;
        case 3:
          page = Language2Lesson3Page();
          break;
        case 4:
          page = Language2Lesson4Page();
          break;
        case 5:
          page = Language2Lesson5Page();
          break;
        default:
          page = Center(child: Text('Lesson not found'));
      }
    } else if (widget.language == 'Language3') {
      switch (lessonIndex) {
        case 1:
          page = Language3Lesson1Page();
          break;
        case 2:
          page = Language3Lesson2Page();
          break;
        case 3:
          page = Language3Lesson3Page();
          break;
        case 4:
          page = Language3Lesson4Page();
          break;
        case 5:
          page = Language3Lesson5Page();
          break;
        default:
          page = Center(child: Text('Lesson not found'));
      }
    } else {
      page = Center(child: Text('Invalid language'));
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> currentLessonNames = lessonNames[widget.language] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.language == 'Language1' ? 'Chemistry' :
          widget.language == 'Language2' ? 'Physics' :
          'Combined Mathematics',
        ),
        backgroundColor: const Color(0xFF104D6C),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
    Padding(
      padding: const EdgeInsets.only(right: 5.0), // Adjust padding as needed
      child: Image.asset(
        'assets/appbar_logo.png', // Replace with the actual path to your image
        height: 70, // Adjust the height as needed
        width: 70
        ,  // Adjust the width as needed
      ),
    ),
  ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              currentLessonNames.length,
              (index) => SlideTransition(
                position: _buttonAnimations[index],
                child: Container(
                  width: 400,
                  height: 70,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9FB8C4),
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => navigateToLesson(context, index + 1),
                    child: Text(
                      currentLessonNames[index],
                      style: const TextStyle(color: Color(0xFF104D6C)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
