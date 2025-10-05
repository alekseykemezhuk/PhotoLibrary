final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Callbacks

    var onLogInSuccess: (() -> Void)?
    var onLogInError: (() -> Void)?
    var onResetPassword: (() -> Void)?
    
    // MARK: - Properties

    let strings: LoginStrings
    private let keychainService: KeychainServiceProtocol
    private let photoManager: PhotoManagerProtocol
    
    // MARK: - Init
    
    init(strings: LoginStrings, keychainService: KeychainServiceProtocol = KeychainService(),
         photoManager: PhotoManagerProtocol = PhotoManager.shared) {
        self.strings = strings
        self.keychainService = keychainService
        self.photoManager = photoManager
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
        photoManager.deleteAllPhotos()
        onResetPassword?()
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let correctPassword = keychainService.get("password")
        return password == correctPassword
    }

}
