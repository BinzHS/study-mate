import 'package:flutter/material.dart';

class Language2Lesson2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics - Kinematics'),
        backgroundColor: const Color(0xFF104D6C),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
    Padding(
      padding: const EdgeInsets.only(right: 5.0), 
      child: Image.asset(
        'assets/appbar_logo.png', 
        height: 70, 
        width: 70
        ,  
      ),
    ),
  ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text(
              'Introduction to Kinematics',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Kinematics is the branch of physics that describes the motion of objects without considering the causes of motion. In this lesson, we will discuss key concepts such as displacement, velocity, acceleration, and equations of motion.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            
            Image.asset(
              'assets/kinematics_intro.png', 
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            
            const Text(
              '1. Displacement and Distance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Displacement is a vector quantity that represents the shortest path between two points. Distance, on the other hand, is a scalar quantity that measures the total path covered by an object.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            
            Image.asset(
              'assets/displacement_distance.png', 
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            
            const Text(
              '2. Speed and Velocity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Speed is a scalar quantity that measures how fast an object is moving. Velocity is a vector quantity that includes both speed and direction.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            
            Image.asset(
              'assets/speed_velocity.png', 
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            
            const Text(
              '3. Acceleration',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Acceleration is the rate of change of velocity with time. It is a vector quantity and can be positive (speeding up) or negative (slowing down, also called deceleration).',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            
            Image.asset(
              'assets/acceleration.png', 
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            
            const Text(
              '4. Equations of Motion',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The three equations of motion describe the relationship between displacement, velocity, acceleration, and time:\n\n'
              '1. \(v = u + at\)\n'
              '2. \(s = ut + \\frac{1}{2}at^2\)\n'
              '3. \(v^2 = u^2 + 2as\)\n\n'
              'Where:\n'
              '- \(u\): Initial velocity\n'
              '- \(v\): Final velocity\n'
              '- \(a\): Acceleration\n'
              '- \(t\): Time\n'
              '- \(s\): Displacement',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),

           
            Image.asset(
              'assets/equations_of_motion.png', 
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),

            
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
              'Kinematics lays the foundation for understanding motion in physics. The concepts of displacement, velocity, acceleration, and equations of motion are crucial for solving real-world problems. Practice solving problems using these principles to strengthen your understanding.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            
            Image.asset(
              'assets/kinematics_conclusion.png', 
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
