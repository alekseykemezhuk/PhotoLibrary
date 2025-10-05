protocol PasswordFormatValidatorProtocol: AnyObject {
    func isValid(_ password: String) -> Bool
}
