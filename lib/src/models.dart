/// Base class for WebAuthn options
abstract class PublicKeyOptions {
  Map<String, dynamic> toJson();
}

/// Options for creating a new credential (Registration)
class PublicKeyCredentialCreationOptions implements PublicKeyOptions {
  final RpEntity rp;
  final UserEntity user;
  final String challenge;
  final List<PubKeyCredParam> pubKeyCredParams;
  final int? timeout;
  final List<CredentialDescriptor>? excludeCredentials;
  final AuthenticatorSelectionCriteria? authenticatorSelection;
  final String? attestation;
  final Map<String, dynamic>? extensions;

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

/// Options for asserting an existing credential (Authentication/Login)
class PublicKeyCredentialRequestOptions implements PublicKeyOptions {
  final String challenge;
  final int? timeout;
  final String? rpId;
  final List<CredentialDescriptor>? allowCredentials;
  final String? userVerification;
  final Map<String, dynamic>? extensions;

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

class RpEntity {
  final String name;
  final String? id;

  RpEntity({required this.name, this.id});

  Map<String, dynamic> toJson() => {
        'name': name,
        if (id != null) 'id': id,
      };
}

class UserEntity {
  final String name;
  final String id;
  final String displayName;

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

class PubKeyCredParam {
  final String type;
  final int alg;

  PubKeyCredParam({required this.type, required this.alg});

  Map<String, dynamic> toJson() => {'type': type, 'alg': alg};
}

class CredentialDescriptor {
  final String type;
  final String id;
  final List<String>? transports;

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

class AuthenticatorSelectionCriteria {
  final String? authenticatorAttachment;
  final String? residentKey;
  final bool? requireResidentKey;
  final String? userVerification;

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
