import AVFoundation

final class AddPhotoViewModel: AddPhotoViewModelProtocol {
    
    // MARK: - Callbacks
    
    var onPhotoSaved: (() -> Void)?
    
    // MARK: - Properties
    
    var strings: AddPhotoStrings
    private let photoManager: PhotoManagerProtocol

    // MARK: - Init
    
    init(strings: AddPhotoStrings,
         photoManager: PhotoManagerProtocol = PhotoManager.shared) {
        self.strings = strings
        self.photoManager = photoManager
    }
    
    // MARK: - Main Flow
    
    func savePhoto(imageData: Data) {
        if photoManager.savePhoto(imageData) != nil {
            onPhotoSaved?()
        }
    }

    func isCameraPermissionGranted() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .denied {
            return false
        }
        return true
    }

}
