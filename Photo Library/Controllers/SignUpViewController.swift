import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: - @IBOutlets

    @IBOutlet weak var password: UITextField!
    
    //MARK: - @IBActions

    @IBAction func savePressed(_ sender: UIButton) {
        
        guard let password = self.password.text else { return }
        if password != "" {
            Manager.shared.keychain.set(password, forKey: Manager.shared.keychainkey)
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController else { return }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
