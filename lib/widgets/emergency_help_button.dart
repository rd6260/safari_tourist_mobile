import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmergencyHelpButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color primaryColor;
  final Color backgroundColor;
  final String label;
  final bool showLabel;
  final Duration animationDuration;
  final bool enableHaptics;

  const EmergencyHelpButton({
    super.key,
    this.onPressed,
    this.size = 120.0,
    this.primaryColor = Colors.red,
    this.backgroundColor = Colors.white,
    this.label = 'EMERGENCY',
    this.showLabel = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.enableHaptics = true,
  });

  @override
  State<EmergencyHelpButton> createState() => _EmergencyHelpButtonState();
}

class _EmergencyHelpButtonState extends State<EmergencyHelpButton>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _scaleController;
  late Animation<double> _rippleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startRippleAnimation();
  }

  void _initializeAnimations() {
    // Ripple animation for the outer glow effect
    _rippleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    // Scale animation for button press feedback
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  void _startRippleAnimation() {
    _rippleController.repeat();
  }

  // void _stopRippleAnimation() {
  //   _rippleController.stop();
  //   _rippleController.reset();
  // }

  Future<void> _handleTap() async {
    if (widget.enableHaptics) {
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _isPressed = true;
    });

    // Scale down animation
    await _scaleController.forward();
    
    // Brief pause
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Scale back up
    await _scaleController.reverse();

    setState(() {
      _isPressed = false;
    });

    // Call the onPressed callback
    widget.onPressed?.call();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
        _scaleController.reverse();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  width: widget.size + 40, // Extra space for ripple effect
                  height: widget.size + 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated ripple rings
                      ...List.generate(2, (index) {
                        return AnimatedBuilder(
                          animation: _rippleController,
                          builder: (context, child) {
                            final delay = index * 0.3;
                            final animationValue = (_rippleAnimation.value - delay).clamp(0.0, 1.0);
                            
                            return Container(
                              width: widget.size + (30 * animationValue),
                              height: widget.size + (30 * animationValue),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.primaryColor.withValues(alpha: 
                                    (_opacityAnimation.value - (delay * 0.3)).clamp(0.0, 1.0),
                                  ),
                                  width: 1.5,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                      
                      // Main button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isPressed 
                              ? widget.primaryColor.withValues(alpha: 0.9)
                              : widget.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: widget.primaryColor.withValues(alpha: 0.3),
                              blurRadius: _isPressed ? 8 : 12,
                              spreadRadius: _isPressed ? 1 : 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: widget.backgroundColor,
                          size: widget.size * 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Label
          if (widget.showLabel) ...[
            const SizedBox(height: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _isPressed 
                    ? widget.primaryColor.withValues(alpha: 0.8)
                    : widget.primaryColor,
                letterSpacing: 1.2,
              ),
              child: Text(widget.label),
            ),
          ],
        ],
      ),
    );
  }
}

// // Usage example widget
// class EmergencyHelpButtonDemo extends StatelessWidget {
//   const EmergencyHelpButtonDemo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text('Emergency Help Button Demo'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Default button
//             EmergencyHelpButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Emergency alert triggered!'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               },
//             ),
            
//             const SizedBox(height: 60),
            
//             // Custom styled button
//             EmergencyHelpButton(
//               size: 100,
//               primaryColor: Colors.orange[600]!,
//               label: 'HELP',
//               animationDuration: const Duration(milliseconds: 2000),
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Help requested!'),
//                     backgroundColor: Colors.orange,
//                   ),
//                 );
//               },
//             ),
            
//             const SizedBox(height: 60),
            
//             // Compact button without label
//             EmergencyHelpButton(
//               size: 80,
//               showLabel: false,
//               primaryColor: Colors.red[700]!,
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Compact emergency button pressed!'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }