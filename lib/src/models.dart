/// Base class for WebAuthn options.
abstract class PublicKeyOptions {
  /// Serializes the options into a JSON-compatible map.
  Map<String, dynamic> toJson();
}

/// Options for creating a new credential (registration).
class PublicKeyCredentialCreationOptions implements PublicKeyOptions {
  /// Relying Party (RP) information.
  final RpEntity rp;
  /// User information for the new credential.
  final UserEntity user;
  /// Base64url encoded challenge from the server.
  final String challenge;
  /// Supported public key algorithms.
  final List<PubKeyCredParam> pubKeyCredParams;
  /// Optional timeout in milliseconds.
  final int? timeout;
  /// Credentials to exclude from registration.
  final List<CredentialDescriptor>? excludeCredentials;
  /// Authenticator selection preferences.
  final AuthenticatorSelectionCriteria? authenticatorSelection;
  /// Attestation conveyance preference.
  final String? attestation;
  /// WebAuthn extensions, if needed.
  final Map<String, dynamic>? extensions;

  /// Creates registration options for WebAuthn.
  PublicKeyCredentialCreationOptions({
    required this.rp,
    required this.user,
    required this.challenge,
    required this.pubKeyCredParams,
    this.timeout,
    this.excludeCredentials,
    this.authenticatorSelection,
    this.attestation,
    this.extensions,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'rp': rp.toJson(),
      'user': user.toJson(),
      'challenge': challenge,
      'pubKeyCredParams': pubKeyCredParams.map((e) => e.toJson()).toList(),
      if (timeout != null) 'timeout': timeout,
      if (excludeCredentials != null)
        'excludeCredentials': excludeCredentials!.map((e) => e.toJson()).toList(),
      if (authenticatorSelection != null)
        'authenticatorSelection': authenticatorSelection!.toJson(),
      if (attestation != null) 'attestation': attestation,
      if (extensions != null) 'extensions': extensions,
    };
  }
}

/// Options for asserting an existing credential (authentication/login).
class PublicKeyCredentialRequestOptions implements PublicKeyOptions {
  /// Base64url encoded challenge from the server.
  final String challenge;
  /// Optional timeout in milliseconds.
  final int? timeout;
  /// Relying Party ID that must match the effective domain.
  final String? rpId;
  /// Credentials allowed for this assertion.
  final List<CredentialDescriptor>? allowCredentials;
  /// User verification requirement.
  final String? userVerification;
  /// WebAuthn extensions, if needed.
  final Map<String, dynamic>? extensions;

  /// Creates assertion options for WebAuthn.
  PublicKeyCredentialRequestOptions({
    required this.challenge,
    this.timeout,
    this.rpId,
    this.allowCredentials,
    this.userVerification,
    this.extensions,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'challenge': challenge,
      if (timeout != null) 'timeout': timeout,
      if (rpId != null) 'rpId': rpId,
      if (allowCredentials != null)
        'allowCredentials': allowCredentials!.map((e) => e.toJson()).toList(),
      if (userVerification != null) 'userVerification': userVerification,
      if (extensions != null) 'extensions': extensions,
    };
  }
}

/// Relying Party (RP) entity.
class RpEntity {
  /// Display name of the Relying Party.
  final String name;
  /// RP ID (domain) for the Relying Party.
  final String? id;

  /// Creates an RP entity.
  RpEntity({required this.name, this.id});

  Map<String, dynamic> toJson() => {
        'name': name,
        if (id != null) 'id': id,
      };
}

/// User entity for credential creation.
class UserEntity {
  /// Account name (e.g., email).
  final String name;
  /// Base64 encoded user ID.
  final String id;
  /// Human-readable display name.
  final String displayName;

  /// Creates a user entity.
  UserEntity({
    required this.name,
    required this.id,
    required this.displayName,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'displayName': displayName,
      };
}

/// Supported public key credential parameters.
class PubKeyCredParam {
  /// Credential type, usually "public-key".
  final String type;
  /// COSE algorithm identifier (e.g., -7 for ES256).
  final int alg;

  /// Creates a public key credential parameter.
  PubKeyCredParam({required this.type, required this.alg});

  Map<String, dynamic> toJson() => {'type': type, 'alg': alg};
}

/// Credential descriptor used for allow/exclude lists.
class CredentialDescriptor {
  /// Credential type, usually "public-key".
  final String type;
  /// Base64url encoded credential ID.
  final String id;
  /// Transport hints (e.g., "internal", "usb").
  final List<String>? transports;

  /// Creates a credential descriptor.
  CredentialDescriptor({
    required this.type,
    required this.id,
    this.transports,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        if (transports != null) 'transports': transports,
      };
}

/// Authenticator selection preferences for registration.
class AuthenticatorSelectionCriteria {
  /// Preferred authenticator attachment (platform/cross-platform).
  final String? authenticatorAttachment;
  /// Resident key requirement (preferred/required/discouraged).
  final String? residentKey;
  /// Whether a resident key is required.
  final bool? requireResidentKey;
  /// User verification requirement.
  final String? userVerification;

  /// Creates authenticator selection preferences.
  AuthenticatorSelectionCriteria({
    this.authenticatorAttachment,
    this.residentKey,
    this.requireResidentKey,
    this.userVerification,
  });

  Map<String, dynamic> toJson() {
    return {
      if (authenticatorAttachment != null)
        'authenticatorAttachment': authenticatorAttachment,
      if (residentKey != null) 'residentKey': residentKey,
      if (requireResidentKey != null) 'requireResidentKey': requireResidentKey,
      if (userVerification != null) 'userVerification': userVerification,
    };
  }
}
