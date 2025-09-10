import Foundation

final class PasswordFormatValidator: PasswordValidating {
    
    func isValid(_ password: String) -> Bool {
        let regex = "^[A-Za-z0-9]{4,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
}
