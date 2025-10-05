import Foundation

final class CollectionViewModel: CollectionViewModelProtocol {
    
    // MARK: - Callbacks
    
    var onPhotosUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onPasswordUpdated: (() -> Void)?
    var onPasswordUpdateFailed: (() -> Void)?
    
    // MARK: - Properties
    
    private(set) var photos: [PhotoModel] = []
    
    var strings: CollectionViewStrings
    private let photoManager: PhotoManagerProtocol
    private let passwordFormatValidator: PasswordFormatValidatorProtocol
    private let keychainService: KeychainServiceProtocol
    
    // MARK: - Init
    
    init(strings: CollectionViewStrings,
         passwordFormatValidator: PasswordFormatValidatorProtocol = PasswordFormatValidator(),
         keychainService: KeychainServiceProtocol = KeychainService(),
         photoManager: PhotoManagerProtocol = PhotoManager.shared) {
        self.strings = strings
        self.photoManager = photoManager
        self.passwordFormatValidator = passwordFormatValidator
        self.keychainService = keychainService
    }
    
    // MARK: - Main flow
    
    func loadPhotos() {
        guard isNeededReloadData() else { return }
        
        onLoadingStateChanged?(true)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let loadedPhotos = self.photoManager.loadPhotos()
            
            DispatchQueue.main.async {
                self.photos = loadedPhotos
                self.onPhotosUpdated?()
                self.onLoadingStateChanged?(false)
            }
        }
    }
    
    func isNeededReloadData() -> Bool {
        return photos.count != photoManager.loadPhotos().count
    }

    func updatePassword(_ newPassword: String) {
        if passwordFormatValidator.isValid(newPassword) {
            keychainService.set(newPassword, for: "password")
            onPasswordUpdated?()
        } else {
            onPasswordUpdateFailed?()
        }
    }
    
}
