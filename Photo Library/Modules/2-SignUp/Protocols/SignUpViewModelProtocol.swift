protocol SignUpViewModelProtocol: AnyObject {
    var onSignUpSuccess: (() -> Void)? { get set }
    var onSignUpError: (() -> Void)? { get set }
    var strings: SignUpStrings { get }
    
    func didTapSave(_ password: String)
}
