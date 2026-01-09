import 'package:flutter/material.dart';
import 'package:web_authn_web/web_authn_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _webAuthnWebPlugin = WebAuthnWeb();
  String _registerRpName = 'ACME Corp';
  String _registerRpId = 'localhost';
  String _registerUserName = 'user@example.com';
  String _registerUserId = 'CAMW';
  String _registerDisplayName = 'User Name';
  String _registerChallenge = 'Y2hhbGxlbmdl';
  String _registerAuthenticatorAttachment = 'platform';
  String _registerResidentKey = 'required';
  String _registerAttestation = 'direct';
  int _registerTimeoutMs = 60000;
  String _signChallenge = 'Y2hhbGxlbmdl';
  String _signRpId = 'localhost';
  String _signUserVerification = 'preferred';
  int _signTimeoutMs = 60000;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _showRegisterDialog(context);
                    },
                    child: const Text('Register Passkey'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await _showSignDialog(context);
                    },
                    child: const Text('Sign (Login)'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  int _parseInt(String value, int fallback) {
    final parsed = int.tryParse(value.trim());
    return parsed ?? fallback;
  }

  Future<void> _showRegisterDialog(BuildContext context) async {
    final rpNameController = TextEditingController(text: _registerRpName);
    final rpIdController = TextEditingController(text: _registerRpId);
    final userNameController = TextEditingController(text: _registerUserName);
    final userIdController = TextEditingController(text: _registerUserId);
    final displayNameController =
        TextEditingController(text: _registerDisplayName);
    final challengeController =
        TextEditingController(text: _registerChallenge);
    final attachmentController =
        TextEditingController(text: _registerAuthenticatorAttachment);
    final residentKeyController =
        TextEditingController(text: _registerResidentKey);
    final attestationController =
        TextEditingController(text: _registerAttestation);
    final timeoutController =
        TextEditingController(text: _registerTimeoutMs.toString());

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Register Passkey'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: rpNameController,
                  decoration: const InputDecoration(labelText: 'RP Name'),
                ),
                TextField(
                  controller: rpIdController,
                  decoration: const InputDecoration(labelText: 'RP ID'),
                ),
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(labelText: 'User Name'),
                ),
                TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(labelText: 'User ID'),
                ),
                TextField(
                  controller: displayNameController,
                  decoration: const InputDecoration(labelText: 'Display Name'),
                ),
                TextField(
                  controller: challengeController,
                  decoration: const InputDecoration(labelText: 'Challenge'),
                ),
                TextField(
                  controller: attachmentController,
                  decoration: const InputDecoration(
                    labelText: 'Authenticator Attachment',
                  ),
                ),
                TextField(
                  controller: residentKeyController,
                  decoration: const InputDecoration(labelText: 'Resident Key'),
                ),
                TextField(
                  controller: attestationController,
                  decoration: const InputDecoration(labelText: 'Attestation'),
                ),
                TextField(
                  controller: timeoutController,
                  decoration: const InputDecoration(labelText: 'Timeout (ms)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Register'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _registerRpName = rpNameController.text.trim();
      _registerRpId = rpIdController.text.trim();
      _registerUserName = userNameController.text.trim();
      _registerUserId = userIdController.text.trim();
      _registerDisplayName = displayNameController.text.trim();
      _registerChallenge = challengeController.text.trim();
      _registerAuthenticatorAttachment = attachmentController.text.trim();
      _registerResidentKey = residentKeyController.text.trim();
      _registerAttestation = attestationController.text.trim();
      _registerTimeoutMs =
          _parseInt(timeoutController.text, _registerTimeoutMs);
    });

    try {
      final options = PublicKeyCredentialCreationOptions(
        rp: RpEntity(name: _registerRpName, id: _registerRpId),
        user: UserEntity(
          name: _registerUserName,
          id: _registerUserId,
          displayName: _registerDisplayName,
        ),
        challenge: _registerChallenge,
        // base64url encoded challenge
        pubKeyCredParams: [
          PubKeyCredParam(type: 'public-key', alg: -7), // ES256
          PubKeyCredParam(type: 'public-key', alg: -257), // RS256
        ],
        authenticatorSelection: AuthenticatorSelectionCriteria(
          authenticatorAttachment:
              _registerAuthenticatorAttachment.isEmpty
                  ? null
                  : _registerAuthenticatorAttachment,
          residentKey:
              _registerResidentKey.isEmpty ? null : _registerResidentKey,
        ),
        timeout: _registerTimeoutMs,
        attestation: _registerAttestation.isEmpty ? null : _registerAttestation,
      );

      final result = await _webAuthnWebPlugin.register(options);
      print('Registration result: $result');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
    } catch (e) {
      print('Registration error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  Future<void> _showSignDialog(BuildContext context) async {
    final challengeController = TextEditingController(text: _signChallenge);
    final rpIdController = TextEditingController(text: _signRpId);
    final userVerificationController =
        TextEditingController(text: _signUserVerification);
    final timeoutController =
        TextEditingController(text: _signTimeoutMs.toString());

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign (Login)'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: challengeController,
                  decoration: const InputDecoration(labelText: 'Challenge'),
                ),
                TextField(
                  controller: rpIdController,
                  decoration: const InputDecoration(labelText: 'RP ID'),
                ),
                TextField(
                  controller: userVerificationController,
                  decoration:
                      const InputDecoration(labelText: 'User Verification'),
                ),
                TextField(
                  controller: timeoutController,
                  decoration: const InputDecoration(labelText: 'Timeout (ms)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sign'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _signChallenge = challengeController.text.trim();
      _signRpId = rpIdController.text.trim();
      _signUserVerification = userVerificationController.text.trim();
      _signTimeoutMs = _parseInt(timeoutController.text, _signTimeoutMs);
    });

    try {
      final options = PublicKeyCredentialRequestOptions(
        challenge: _signChallenge, // base64url encoded challenge
        timeout: _signTimeoutMs,
        rpId: _signRpId.isEmpty ? null : _signRpId,
        userVerification:
            _signUserVerification.isEmpty ? null : _signUserVerification,
      );

      final result = await _webAuthnWebPlugin.sign(options);
      print('Sign result: $result');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign successful')),
      );
    } catch (e) {
      print('Sign error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign failed: $e')),
      );
    }
  }
}
