import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterPasswordLabel: UILabel!
    
    //MARK: - Properties
    
    var textY: CGFloat = 0
    var correctPassword = Manager.shared.keychain.get(Manager.shared.keychainkey)

    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPasswordButton.sizeToFit()
        enterPasswordLabel.sizeToFit()
        registerForKeyboardNotifications()
    }
    
    //MARK: - @IBActions

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if passwordTextField.text == correctPassword {
            showColVC()
        } else {
            view.endEditing(true)
            showIncorrectPasswordAlert()
            self.passwordTextField.text = ""
        }
    }
    
    @IBAction func forgotButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Reset password?", message: "Your photos will be deleted from this app", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) {_ in 
            if var imagesUrlArray = UserDefaults.standard.value([Images].self, forKey: "images") {
                imagesUrlArray.removeAll()
                UserDefaults.standard.set(encodable: imagesUrlArray, forKey: "images")
                self.correctPassword = ""
                self.navigationController?.popViewController(animated: true)
            }
        }
        let noAction = UIAlertAction(title: "No", style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    //MARK: - Flow methods
    
    private func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollViewBottomConstraint.constant = 0
        } else if textY > keyboardScreenEndFrame.origin.y {
            scrollViewBottomConstraint.constant = textFieldBottomConstraint.constant
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    private func showColVC(){
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController else { return }
        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showIncorrectPasswordAlert() {
        
        let alert = UIAlertController(title: "Incorrect password", message: "Try again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.view.endEditing(true)
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}


