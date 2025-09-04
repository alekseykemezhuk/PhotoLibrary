final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Callbacks

    var onLogInSuccess: (() -> Void)?
    var onLogInError: (() -> Void)?
    var onResetPassword: (() -> Void)?
    
    // MARK: - Properties

    let strings: LoginStrings
    let keychainService: KeychainServiceProtocol
    
    // MARK: - Init
    
    init(strings: LoginStrings, keychainService: KeychainServiceProtocol = KeychainService()) {
        self.strings = strings
        self.keychainService = keychainService
    }
    
    // MARK: - Main Flow
    
    func didTapLogin(_ password: String) {
        if isPasswordValid(password) {
            onLogInSuccess?()
        } else {
            onLogInError?()
        }
    }
    
    func resetPassword() {
        keychainService.set("", for: "password")
        onResetPassword?()
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let correctPassword = keychainService.get("password")
        return password == correctPassword
    }

}
