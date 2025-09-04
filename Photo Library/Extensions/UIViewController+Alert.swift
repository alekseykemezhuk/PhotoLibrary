import UIKit

extension UIViewController {
    func showAlert(
        title: String,
        message: String,
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
