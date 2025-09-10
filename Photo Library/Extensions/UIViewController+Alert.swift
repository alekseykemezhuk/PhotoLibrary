import UIKit

extension UIViewController {
    func showAlert(title: String, message: String,
                   actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func showTextFieldAlert(
            title: String,
            message: String,
            placeholder: String? = nil,
            isSecure: Bool = false,
            confirmTitle: String = "OK",
            cancelTitle: String = "Cancel",
            onConfirm: @escaping (String) -> Void
        ) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = placeholder
                textField.isSecureTextEntry = isSecure
            }
            let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                if let text = alert.textFields?.first?.text, !text.isEmpty {
                    onConfirm(text)
                }
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            present(alert, animated: true)
        }
}
