import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SecureAuthScreen extends StatefulWidget {
  @override
  _SecureAuthScreenState createState() => _SecureAuthScreenState();
}

class _SecureAuthScreenState extends State<SecureAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  int failedAttempts = 0;
  bool showPinScreen = false;

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to unlock',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        setState(() {
          failedAttempts = 0;
        });
        // Navigate to home or show content
        print("Fingerprint successful");
      } else {
        _handleFailedAttempt();
      }
    } catch (e) {
      print("Biometric error: $e");
      _handleFailedAttempt();
    }
  }

  void _handleFailedAttempt() {
    setState(() {
      failedAttempts++;
      if (failedAttempts >= 3) {
        showPinScreen = true;
      }
    });
  }

  void _verifyPin(String pin) {
    const correctPin = '1234'; // Store securely in production
    if (pin == correctPin) {
      // Unlock success
      print("PIN verified successfully");
    } else {
      print("Wrong PIN");
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate(); // Trigger auth on start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Secure Auth")),
      body: Center(
        child:
            showPinScreen
                ? PinEntryWidget(onSubmit: _verifyPin)
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Authenticate with fingerprint"),
                    ElevatedButton(
                      onPressed: _authenticate,
                      child: Text("Try Again"),
                    ),
                  ],
                ),
      ),
    );
  }
}

class PinEntryWidget extends StatefulWidget {
  final Function(String) onSubmit;

  PinEntryWidget({required this.onSubmit});

  @override
  _PinEntryWidgetState createState() => _PinEntryWidgetState();
}

class _PinEntryWidgetState extends State<PinEntryWidget> {
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Enter PIN", style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        ElevatedButton(
          onPressed: () => widget.onSubmit(pinController.text),
          child: Text("Submit"),
        ),
      ],
    );
  }
}
