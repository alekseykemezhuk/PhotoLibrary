import UIKit
import AVFoundation

protocol AddPhotoViewControllerDelegate: AnyObject {
    func vcWasClosed()
}

class AddPhotoViewController: UIViewController {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Properties
    
    let picker = UIImagePickerController()
    weak var delegate: AddPhotoViewControllerDelegate?

    //MARK: - Lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showImagePickerAlert()
    }

    //MARK: - @IBActions
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        guard let newImage = imageView.image else { return }
        guard let newImageName = Manager.shared.saveImage(image: newImage) else { return }
        let newImageForImages = Images(imageArray: newImageName)
        if var imagesArray = UserDefaults.standard.value([Images].self, forKey: "images") {
            imagesArray.append(newImageForImages)
            UserDefaults.standard.set(encodable: imagesArray, forKey: "images")
        } else {
            var photosArray = [Images]()
            photosArray.append(newImageForImages)
            UserDefaults.standard.set(encodable: photosArray, forKey: "images")
        }
        delegate?.vcWasClosed()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Flow methods
    
    private func showImagePickerAlert() {
        
        let alert = UIAlertController(title: "Choose a source", message: nil, preferredStyle: .actionSheet)
        let firstAlertAction = UIAlertAction(title: "Library", style: .default) { _ in
            self.imagePickerSetup(.photoLibrary)
        }
        let secondAlertAction = UIAlertAction(title: "Camera", style: .default) { _ in
            if self.cameraPermissionGranted() {
                self.imagePickerSetup(.camera)
            } else {
                self.showDeniedAlert()
            }
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(firstAlertAction)
        alert.addAction(secondAlertAction)
        alert.addAction(cancelAlertAction)
        present(alert, animated: true)
    }
    
    private func imagePickerSetup(_ source: UIImagePickerController.SourceType) {
        
        picker.sourceType = source
        picker.allowsEditing = false
        picker.delegate = self
        present(self.picker, animated: true)
    }
    
    private func cameraPermissionGranted() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .denied {
            return false
        }
        return true
    }
    
    private func showDeniedAlert() {
        
        let alert = UIAlertController(title: "Access denied", message: "Change permisson in iPhone settings", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.showImagePickerAlert()
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}




