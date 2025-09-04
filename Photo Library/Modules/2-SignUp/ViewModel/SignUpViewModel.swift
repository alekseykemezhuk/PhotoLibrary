import Foundation
import KeychainSwift

final class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - Callbacks

    var onSignUpSuccess: (() -> Void)?
    var onSignUpError: (() -> Void)?
    
    // MARK: - Properties
    
    let strings: SignUpStrings
    let keychainService: KeychainServiceProtocol
    
    // MARK: - Init
    
    init(strings: SignUpStrings, keychainService: KeychainServiceProtocol = KeychainService()) {
        self.strings = strings
        self.keychainService = keychainService
    }
    
    // MARK: - Main Flow
    
    func didTapSave(_ password: String) {
        if isPasswordStrongEnough(password) {
            savePassword(password)
            onSignUpSuccess?()
        } else {
            onSignUpError?()
        }
    }
    
    private func isPasswordStrongEnough(_ password: String) -> Bool {
        let regex = "^[A-Za-z0-9]{4,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private func savePassword(_ password: String) {
        keychainService.set(password, for: "password")
    }
}
