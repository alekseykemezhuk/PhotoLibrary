final class CollectionViewModel: CollectionViewModelProtocol {
    
    // MARK: - Callbacks
    
    var onUpdatePasswordSuccess: (() -> Void)?
    var onUpdatePasswordError: (() -> Void)?
    
    // MARK: - Properties

    var strings: CollectionViewStrings
    private var passwordFormatValidator: PasswordValidating
    private var keychainService: KeychainServiceProtocol
    
    // MARK: - Init

    init(strings: CollectionViewStrings,
         passwordFormatValidator: PasswordValidating = PasswordFormatValidator(),
         keychainService: KeychainServiceProtocol = KeychainService()) {
        self.strings = strings
        self.passwordFormatValidator = passwordFormatValidator
        self.keychainService = keychainService
    }
    
    // MARK: - Main flow

    func updatePassword(_ newPassword: String) {
        if passwordFormatValidator.isValid(newPassword) {
            keychainService.set(newPassword, for: "password")
            onUpdatePasswordSuccess?()
        } else {
            onUpdatePasswordError?()
        }
    }
    
}
