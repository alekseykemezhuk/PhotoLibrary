import KeychainSwift

final class KeychainService: KeychainServiceProtocol {
    
    private let keychain = KeychainSwift()
    
    func set(_ value: String, for key: String) {
        keychain.set(value, forKey: key)
    }
    
    func get(_ key: String) -> String? {
        return keychain.get(key)
    }
    
    
}
