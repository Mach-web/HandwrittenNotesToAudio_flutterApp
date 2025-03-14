import 'package:flutter/material.dart';
import 'dart:math';

class RandomButtonsScreen extends StatefulWidget {
  const RandomButtonsScreen({Key? key}) : super(key: key);

  @override
  _RandomButtonsScreenState createState() => _RandomButtonsScreenState();
}

class _RandomButtonsScreenState extends State<RandomButtonsScreen> {
  final Random _random = Random();
final Map<String, IconData> buttonLabels = {
      'GitHub': Icons.code,
      'PayPal': Icons.payment,
      'M-Pesa': Icons.money,
      'Payoneer': Icons.credit_card,
      'Za Kabej': Icons.business,
      'Binance': Icons.monetization_on,
      'Hire Me': Icons.person,
      'Contact': Icons.contact_mail,
      'WhatsApp': Icons.message,
      'LinkedIn': Icons.business_center,
      'XKCD': Icons.book,
      'Share': Icons.share
      };


  // Generate a random color
  Color _getRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      0.8 + _random.nextDouble() * 0.2,
    );
  }

  // Generate a random button style with improved text visibility
  ButtonStyle _getRandomButtonStyle() {
    final backgroundColor = _getRandomColor();
    // Calculate the luminance of the background color
    final luminance = (0.299 * backgroundColor.red + 
                       0.587 * backgroundColor.green + 
                       0.114 * backgroundColor.blue) / 255;
    
    // Choose text color based on background luminance for better contrast
    final textColor = luminance > 0.5 ? Colors.black : Colors.white;
    
    final styles = [
      ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_random.nextDouble() * 20),
        ),
      ),
      OutlinedButton.styleFrom(
        foregroundColor: backgroundColor,
        backgroundColor: Colors.white,
        side: BorderSide(color: backgroundColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_random.nextDouble() * 20),
        ),
      ),
      TextButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_random.nextDouble() * 20),
        ),
      ),
    ];
    return styles[_random.nextInt(styles.length)];
  }

  // Generate a random size
  Size _getRandomSize() {
    return Size(
      80 + _random.nextDouble() * 100,  // Increased minimum width
      40 + _random.nextDouble() * 50,   // Increased minimum height
    );
  }

  // Generate a random position
  Offset _getRandomPosition(Size screenSize, Size buttonSize) {
    return Offset(
      _random.nextDouble() * (screenSize.width - buttonSize.width),
      _random.nextDouble() * (screenSize.height - buttonSize.height),
    );
  }

  // Generate a random rotation angle
  double _getRandomAngle() {
    return (_random.nextBool() ? 1 : -1) * _random.nextDouble() * 0.3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
          return Stack(
            children: List.generate(buttonLabels.length, (index) {
              final buttonSize = _getRandomSize();
              final position = _getRandomPosition(screenSize, buttonSize);
              final angle = _getRandomAngle();
              
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: Transform.rotate(
                  angle: angle,
                  child: SizedBox(
                    width: buttonSize.width,
                    height: buttonSize.height,
                    child: ElevatedButton.icon(
                      icon: Icon(buttonLabels.values.elementAt(index)),
                      style: _getRandomButtonStyle(),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${buttonLabels[index]} clicked!')),
                        );
                      },
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          buttonLabels.keys.elementAt(index),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,  // Always bold for better visibility
                            fontSize: 16 + _random.nextDouble() * 8,  // Increased font size
                            shadows: [  // Add text shadow for better contrast
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}