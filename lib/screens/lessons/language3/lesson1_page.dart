import 'package:flutter/material.dart';

class Language3Lesson1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algebra'),
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
      body: SingleChildScrollView(  // Makes the content scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Algebra in Combined Mathematics',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Algebra is one of the key areas in Combined Mathematics, dealing with variables, constants, and the relationships between them. '
              'Algebraic expressions and equations are used to model real-world situations, solve problems, and make predictions.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Key Concepts:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            // Linear Equations
            Text(
              '- **Linear Equations**:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A linear equation is an equation of the form:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( ax + b = 0 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'where \(a\) and \(b\) are constants, and \(x\) is the variable. The solution to this equation is the value of \(x\) that satisfies the equation.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Example: Solve \( 3x + 5 = 11 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Step 1: Subtract 5 from both sides:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( 3x = 6 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Step 2: Divide both sides by 3:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( x = 2 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 16),
            // Quadratic Equations
            Text(
              '- **Quadratic Equations**:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A quadratic equation is of the form:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( ax^2 + bx + c = 0 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'where \(a\), \(b\), and \(c\) are constants, and \(x\) is the variable. Quadratic equations are solved using factoring, completing the square, or the quadratic formula.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Example: Solve \( x^2 - 5x + 6 = 0 \) by factoring.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Step 1: Factor the equation:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( (x - 2)(x - 3) = 0 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Step 2: Set each factor equal to 0:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( x - 2 = 0 \) or \( x - 3 = 0 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Step 3: Solve for \(x\):',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( x = 2 \) or \( x = 3 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 16),
            // Polynomials
            Text(
              '- **Polynomials**:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A polynomial is an expression of the form:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( a_nx^n + a_{n-1}x^{n-1} + ... + a_1x + a_0 \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'where \(a_n, a_{n-1}, ..., a_0\) are constants, and \(x\) is the variable. Polynomials are used to represent a variety of mathematical models.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Example: Simplify the polynomial \( 2x^2 + 3x - 5x^2 + 4x \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Step 1: Combine like terms:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\( 2x^2 - 5x^2 = -3x^2 \) and \( 3x + 4x = 7x \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Final result: \( -3x^2 + 7x \)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Practice Problems:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF104D6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '1. Solve \( 2x + 7 = 13 \)\n'
              '2. Solve \( x^2 - 4x - 5 = 0 \) by factoring\n'
              '3. Simplify the polynomial \( 3x^2 + 4x - 2x^2 + 6x \)',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
