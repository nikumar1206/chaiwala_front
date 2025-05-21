//
//  Keychain.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/6/25.
//
import Foundation
import Security

struct KeychainError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

class KeychainHelper {

    static let shared = KeychainHelper()

    private var prefix: String

    private init() {
        self.prefix = "com.chaiwala."
    }

    func set(_ token: String, forKey key: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError("Failed to encode token")
        }

        let prefixedKey = "\(prefix)\(key)"

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: prefixedKey,
        ]

        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]

        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

        if status == errSecItemNotFound {
            // Add item if it doesn't exist
            var newItem = query
            newItem[kSecValueData as String] = data
            newItem[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked

            let addStatus = SecItemAdd(newItem as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainError("Failed to add item: \(addStatus)")
            }
        } else if status != errSecSuccess {
            throw KeychainError("Failed to update item: \(status)")
        }
    }


    func get(forKey key: String) -> String? {

        let prefixedKey = "\(prefix)\(key)"

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: prefixedKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            print("got \(key) from keychain", data)
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }

    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }

    func clearAll() {
        delete(forKey: "\(prefix)accessToken")
        delete(forKey: "\(prefix)refreshToken")
    }
}
