import 'package:flutter/material.dart';

class Language2Lesson1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics - Mechanics'),
        backgroundColor: const Color(0xFF104D6C),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            const Text(
              'Introduction to Mechanics',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mechanics is the branch of physics that deals with the motion of objects and the forces that act upon them. It is divided into two main branches:',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Kinematics: Describes motion without considering its causes.\n'
              '2. Dynamics: Focuses on the forces and their effects on motion.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Introduction Image
            Image.asset(
              'assets/mechanics1.png',
              height: 450,
              width: 400,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            // Section Title
            const Text(
              'Key Concepts in Mechanics',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 12),

            // Concept 1
            const Text(
              '1. Motion in One Dimension',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Motion in a straight line can be described by parameters like velocity, acceleration, and displacement.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            
            Image.asset(
              'assets/mechanics2.png', // Image showing an example of one-dimensional motion
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            // Concept 2
            const Text(
              '2. Newton\'s Laws of Motion',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Newton\'s laws form the foundation of classical mechanics and describe the relationship between forces and motion.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            const Text(
              'Examples:\n'
              '• First Law (Inertia): A body remains at rest or in uniform motion unless acted upon by a force.\n'
              '• Second Law (F=ma): Force equals mass times acceleration.\n'
              '• Third Law: For every action, there is an equal and opposite reaction.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Newton's Laws of Motion Image
            Image.asset(
              'assets/mechanics3.png', 
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            // Concept 3
            const Text(
              '3. Circular Motion',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Circular motion occurs when an object moves along a curved path or a circle. Parameters include angular velocity, centripetal force, and period.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Circular Motion Image
            Image.asset(
              'assets/mechanics4.png', // Placeholder for an image showing circular motion concepts
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            // Closing Section
            const Text(
              'Conclusion',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mechanics provides the basis for understanding various physical phenomena. It helps explain the motion of celestial bodies, engineering systems, and everyday objects.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
