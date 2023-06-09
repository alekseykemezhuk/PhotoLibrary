import UIKit
import SwiftyKeychainKit

class CollectionViewController: UIViewController {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }
    
    //MARK: - @IBActions
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        collectionView.reloadData()
        let password = ""
        try? Manager.shared.keychain.set(password, for: Manager.shared.keychainkey)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func plusPressed(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddPhotoViewController") as? AddPhotoViewController else { return }
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

