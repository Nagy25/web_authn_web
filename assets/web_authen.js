'use strict';

window.deleteAuth = function (options) {
    return new Promise((resolve, reject) => {
        try {
            const webAuthn = new WebAuthn();
            webAuthn.del(options, (result) => {
                result.error ? reject(new Error(result.error)) : resolve(result);
            });
        } catch (error) {
            console.error('[WebAuthn-Fx] Error in window.deleteAuth:', error);
            reject(error);
        }
    });
};

window.register = function (options) {
    return new Promise((resolve, reject) => {
        try {
            const webAuthn = new WebAuthn();
            webAuthn.register(options, (result) => {
                result.error ? reject(new Error(result.error)) : resolve(result);
            });
        } catch (error) {
            console.error('[WebAuthn-Fx] Error in window.register:', error);
            reject(error);
        }
    });
};

window.sign = function (options) {
    return new Promise((resolve, reject) => {
        try {
            const webAuthn = new WebAuthn();
            webAuthn.sign(options, (result) => {
                result.error ? reject(new Error(result.error)) : resolve(result);
            });
        } catch (error) {
            console.error('[WebAuthn-Fx] Error in window.sign:', error);
            reject(error);
        }
    });
};

function WebAuthn(notifyCallback = null) {
    if (notifyCallback) {
        this.setNotify(notifyCallback);
    }
}

WebAuthn.prototype.register = function (publicKey, callback) {
    try {
        console.log('[WebAuthn-Fx][register] Incoming publicKey:', JSON.stringify(publicKey));
        let publicKeyCredential = Object.assign({}, publicKey);
        publicKeyCredential.user.id = this._bufferDecode(publicKey.user.id);
        publicKeyCredential.challenge = this._bufferDecode(this._base64Decode(publicKey.challenge));
        if (publicKey.excludeCredentials) {
            publicKeyCredential.excludeCredentials = this._credentialDecode(publicKey.excludeCredentials);
        }
        console.log('[WebAuthn-Fx][register] Final publicKeyCredential:', publicKeyCredential);

        navigator.credentials.create({ publicKey: publicKeyCredential }).then(
            (data) => this._registerCallback(data, callback),
            (error) => {
                console.error('[WebAuthn-Fx][register] create() error:', error);
                callback({ error: error.message });
            }
        );
    } catch (error) {
        console.error('[WebAuthn-Fx][register] Exception:', error);
        callback({ error: error.message });
    }
};

WebAuthn.prototype.del = async function (publicKey, callback) {
    try {
        console.log('[WebAuthn-Fx][delete] Received publicKey:', JSON.stringify(publicKey));
        let publicKeyCredential = Object.assign({}, publicKey);

        await PublicKeyCredential.signalUnknownCredential({
            credentialId: publicKeyCredential.id,
            rpId: publicKeyCredential.rpId,
        });

        console.log('[WebAuthn-Fx][delete] Credential deletion signal sent for:', publicKeyCredential.id);
        callback({ success: true, message: "Passkey deletion signal sent successfully." });
    } catch (error) {
        console.error('[WebAuthn-Fx][delete] Error:', error);
        callback({ error: error.message });
    }
};

WebAuthn.prototype.sign = function (publicKey, callback) {
    try {
        console.log('[WebAuthn-Fx][sign] Incoming publicKey:', JSON.stringify(publicKey));
        let publicKeyCredential = Object.assign({}, publicKey);
        publicKeyCredential.challenge = this._bufferDecode(this._base64Decode(publicKey.challenge));
        if (publicKey.allowCredentials) {
            publicKeyCredential.allowCredentials = this._credentialDecode(publicKey.allowCredentials);
        }
        console.log('[WebAuthn-Fx][sign] Final publicKeyCredential:', publicKeyCredential);

        navigator.credentials.get({ publicKey: publicKeyCredential }).then(
            (data) => this._signCallback(data, callback),
            (error) => {
                console.error('[WebAuthn-Fx][sign] get() error:', error);
                callback({ error: error.message });
            }
        );
    } catch (error) {
        console.error('[WebAuthn-Fx][sign] Exception:', error);
        callback({ error: error.message });
    }
};

WebAuthn.prototype._registerCallback = function (publicKey, callback) {
    try {
        const processed = {
            id: publicKey.id,
            type: publicKey.type,
            rawId: this._bufferEncode(publicKey.rawId),
            response: {
                clientDataJSON: this._bufferEncode(publicKey.response.clientDataJSON).replace(/=/g, ''),
                attestationObject: this._bufferEncode(publicKey.response.attestationObject)
            }
        };
        console.log('[WebAuthn-Fx][registerCallback] Processed credential:', processed);
        callback(processed);
    } catch (error) {
        console.error('[WebAuthn-Fx][registerCallback] Error:', error);
        callback({ error: error.message });
    }
};

WebAuthn.prototype._signCallback = function (publicKey, callback) {
    try {
        const processed = {
            id: publicKey.id,
            type: publicKey.type,
            rawId: this._bufferEncode(publicKey.rawId),
            response: {
                authenticatorData: this._bufferEncode(publicKey.response.authenticatorData).replace(/=/g, ''),
                clientDataJSON: this._bufferEncode(publicKey.response.clientDataJSON).replace(/=/g, ''),
                signature: this._bufferEncode(publicKey.response.signature),
                userHandle: publicKey.response.userHandle ? this._bufferEncode(publicKey.response.userHandle) : null,
            },
        };
        console.log('[WebAuthn-Fx][signCallback] Processed credential:', processed);
        callback(processed);
    } catch (error) {
        console.error('[WebAuthn-Fx][signCallback] Error:', error);
        callback({ error: error.message });
    }
};

WebAuthn.prototype._bufferEncode = function (value) {
    try {
        return window.btoa(String.fromCharCode.apply(null, new Uint8Array(value)));
    } catch (e) {
        console.error('[WebAuthn-Fx][_bufferEncode] Failed to encode:', value, e);
        throw e;
    }
};

WebAuthn.prototype._bufferDecode = function (value) {
    try {
        const binary = window.atob(value);
        return Uint8Array.from(binary, c => c.charCodeAt(0));
    } catch (e) {
        console.error('[WebAuthn-Fx][_bufferDecode] Failed to decode:', value, e);
        throw e;
    }
};

WebAuthn.prototype._base64Decode = function (input) {
    try {
        input = input.replace(/-/g, '+').replace(/_/g, '/');
        const pad = input.length % 4;
        if (pad) {
            if (pad === 1) throw new Error('InvalidLengthError: bad base64 length');
            input += new Array(5 - pad).join('=');
        }
        return input;
    } catch (e) {
        console.error('[WebAuthn-Fx][_base64Decode] Failed on:', input, e);
        throw e;
    }
};

WebAuthn.prototype._credentialDecode = function (credentials) {
    const self = this;
    return credentials.map(function (data) {
        try {
            return {
                id: self._bufferDecode(self._base64Decode(data.id)),
                type: data.type,
                transports: data.transports,
            };
        } catch (e) {
            console.error('[WebAuthn-Fx][_credentialDecode] Failed on:', data, e);
            throw e;
        }
    });
};

WebAuthn.prototype.notSupportedMessage = function () {
    if (!window.isSecureContext && window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
        return 'not_secured';
    }
    return 'not_supported';
};

WebAuthn.prototype._notify = function (message, isError) {
    if (this._notifyCallback) {
        this._notifyCallback(message, isError);
    }
};

WebAuthn.prototype.setNotify = function (callback) {
    this._notifyCallback = callback;
};

WebAuthn.prototype.webAuthnSupport = function () {
    return !(window.PublicKeyCredential === undefined ||
        typeof window.PublicKeyCredential !== 'function' ||
        typeof window.PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable !== 'function');
};
