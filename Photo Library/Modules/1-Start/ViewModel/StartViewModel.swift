final class StartViewModel: StartViewModelProtocol {
    
    // MARK: - Properties
    
    private let strings: StartStrings
    var signUpButtonTitle: String {
        strings.signUpButtonTitle
    }
    
    // MARK: - Init
    
    init(strings: StartStrings) {
        self.strings = strings
    }
}
