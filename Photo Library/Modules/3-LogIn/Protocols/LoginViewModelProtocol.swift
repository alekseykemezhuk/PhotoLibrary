protocol LoginViewModelProtocol: AnyObject {
    var onLogInSuccess: (() -> Void)? { get set }
    var onLogInError: (() -> Void)? { get set }
    var onResetPassword: (() -> Void)? { get set }
    var strings: LoginStrings { get }
    
    func didTapLogin(_ password: String)
    func resetPassword()
}
