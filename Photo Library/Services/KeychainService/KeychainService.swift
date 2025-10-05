import KeychainSwift

final class KeychainService: KeychainServiceProtocol {
    
    // MARK: - Properties
    
    private let keychain = KeychainSwift()
    
    // MARK: - Flow methods
    
    func set(_ value: String, for key: String) {
        keychain.set(value, forKey: key)
    }
    
    func get(_ key: String) -> String? {
        return keychain.get(key)
    }
    
    
}
