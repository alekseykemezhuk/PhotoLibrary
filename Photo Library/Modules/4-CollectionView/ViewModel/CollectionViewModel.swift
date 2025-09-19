import UIKit

final class CollectionViewModel: CollectionViewModelProtocol {
    
    // MARK: - Callbacks
    
    var onPhotosUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onUpdatePasswordSuccess: (() -> Void)?
    var onUpdatePasswordError: (() -> Void)?
    
    // MARK: - Properties
    
    var strings: CollectionViewStrings
    private let photoManager = PhotoManager.shared
    private(set) var photos: [UIImage] = []
    private var passwordFormatValidator: PasswordValidating
    private var keychainService: KeychainServiceProtocol
    
    // MARK: - Init
    
    init(strings: CollectionViewStrings,
         passwordFormatValidator: PasswordValidating = PasswordFormatValidator(),
         keychainService: KeychainServiceProtocol = KeychainService()) {
        self.strings = strings
        self.passwordFormatValidator = passwordFormatValidator
        self.keychainService = keychainService
    }
    
    // MARK: - Main flow
    
    func loadPhotos() {
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
    
    func addPhoto(_ image: UIImage) {
        onLoadingStateChanged?(true)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.photoManager.savePhoto(image) != nil {
                DispatchQueue.main.async {
                    self.photos.append(image)
                    self.onPhotosUpdated?()
                    self.onLoadingStateChanged?(false)
                }
            } else {
                DispatchQueue.main.async {
                    self.onLoadingStateChanged?(false)
                }
            }
        }
    }
    
    func deletePhoto(at index: Int) {
        onLoadingStateChanged?(true)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.photoManager.deletePhoto(at: index)
            DispatchQueue.main.async {
                self.photos.remove(at: index)
                self.onPhotosUpdated?()
                self.onLoadingStateChanged?(false)
            }
        }
    }
    
    func updatePassword(_ newPassword: String) {
        if passwordFormatValidator.isValid(newPassword) {
            keychainService.set(newPassword, for: "password")
            onUpdatePasswordSuccess?()
        } else {
            onUpdatePasswordError?()
        }
    }
    
}
