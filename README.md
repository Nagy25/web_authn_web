# web_authn_web

A Flutter Web implementation for WebAuthn (Web Authentication API), allowing you to register and authenticate users using passkeys/biometrics.

This package wraps the `web_authen.js` logic and exposes it via a clean, strictly typed Dart API.

**Platform support**: Web only (Flutter Web).

## Features

- **Register**: Create a new public key credential.
- **Sign (Login)**: Authenticate using an existing credential.
- **Delete**: Signal deletion of a credential.
- **Typed API**: Use Dart classes like `PublicKeyCredentialCreationOptions` instead of raw Maps.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  web_authn_web: ^0.0.1
```

Or run:

```bash
flutter pub add web_authn_web
```

## Usage

This package automatically injects the required JavaScript code (`web_authen.js`) into your application.

### Requirements

- **Secure context**: WebAuthn requires HTTPS (or `localhost`).
- **Relying Party ID**: `rp.id` (and `rpId` in login) must match your effective domain (e.g., `example.com`).
- **Server side**: You must generate challenges and verify the returned attestation/assertion on your backend.

### Data encoding expectations

- `challenge`: base64url encoded string.
- `user.id`: base64 encoded string (standard base64, not url-safe).
- `allowCredentials[].id` and `excludeCredentials[].id`: base64url encoded string.

### Register a Passkey

```dart
import 'package:web_authn_web/web_authn_web.dart';

final webAuthn = WebAuthnWeb();

final options = PublicKeyCredentialCreationOptions(
  rp: RpEntity(name: 'ACME Corp', id: 'example.com'),
  user: UserEntity(
    name: 'user@example.com',
    id: 'CAMW', // base64 encoded id
    displayName: 'User Name',
  ),
  challenge: 'Y2hhbGxlbmdl', // base64url encoded challenge
  pubKeyCredParams: [
    PubKeyCredParam(type: 'public-key', alg: -7), // ES256
  ],
  authenticatorSelection: AuthenticatorSelectionCriteria(
    authenticatorAttachment: 'platform',
  ),
);

try {
  final result = await webAuthn.register(options);
  print('Registration successful: $result');
} catch (e) {
  print('Registration failed: $e');
}
```

### Authenticate (Sign)

```dart
final options = PublicKeyCredentialRequestOptions(
  challenge: 'Y2hhbGxlbmdl', // base64url encoded challenge
  rpId: 'example.com',
  userVerification: 'required',
);

try {
  final result = await webAuthn.sign(options);
  print('Sign successful: $result');
} catch (e) {
  print('Sign failed: $e');
}
```

### Delete Credential

```dart
try {
  await webAuthn.deleteAuth('credentialId', 'rpId');
} catch (e) {
  print('Delete failed: $e');
}
```

## Notes

- This package only performs the browser-side WebAuthn calls. Always validate the returned data on your server.
- Passkey APIs are not available in all browsers or in insecure contexts.
