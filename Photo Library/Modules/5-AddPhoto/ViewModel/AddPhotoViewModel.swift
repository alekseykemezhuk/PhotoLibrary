import AVFoundation
import UIKit

final class AddPhotoViewModel: AddPhotoViewModelProtocol {
    
    // MARK: - Callbacks
    
    var onPhotoSaved: ((UIImage) -> Void)?
    
    // MARK: - Properties
    
    var strings: AddPhotoStrings
    
    // MARK: - Init
    
    init(strings: AddPhotoStrings) {
        self.strings = strings
    }
    
    // MARK: - Main Flow
    
    func savePhoto(_ image: UIImage) {
        onPhotoSaved?(image)
    }

    func isCameraPermissionGranted() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .denied {
            return false
        }
        return true
    }

}
