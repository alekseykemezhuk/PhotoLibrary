import UIKit
import SwiftyKeychainKit

class StartViewController: UIViewController {

    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let password = try? Manager.shared.keychain.get(Manager.shared.keychainkey)
        if password != "" && password != nil {
            showLoginVC()
        }
    }

    //MARK: - @IBActions
    
    @IBAction func signPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Flow methods
    
    private func showLoginVC() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.navigationController?.pushViewController(controller, animated: false)
    }
}

