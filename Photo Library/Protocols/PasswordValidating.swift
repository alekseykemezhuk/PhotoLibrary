protocol PasswordValidating: AnyObject {
    func isValid(_ password: String) -> Bool
}
