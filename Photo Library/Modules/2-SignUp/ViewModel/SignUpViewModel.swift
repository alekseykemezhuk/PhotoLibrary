import Foundation
import KeychainSwift

final class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - Callbacks

    var onSignUpSuccess: (() -> Void)?
    var onSignUpError: (() -> Void)?
    
    // MARK: - Properties
    
    let strings: SignUpStrings
    private let keychainService: KeychainServiceProtocol
    private let passwordFormatValidator: PasswordFormatValidatorProtocol
    
    // MARK: - Init
    
    init(strings: SignUpStrings, keychainService: KeychainServiceProtocol = KeychainService(),
         passwordFormatValidator: PasswordFormatValidatorProtocol = PasswordFormatValidator()) {
        self.strings = strings
        self.keychainService = keychainService
        self.passwordFormatValidator = passwordFormatValidator
    }
    
    // MARK: - Main Flow
    
    func didTapSave(_ password: String) {
        let isValidPassword = passwordFormatValidator.isValid(password)
        if isValidPassword {
            savePassword(password)
            onSignUpSuccess?()
        } else {
            onSignUpError?()
        }
    }
    
    private func savePassword(_ password: String) {
        keychainService.set(password, for: "password")
    }
}
