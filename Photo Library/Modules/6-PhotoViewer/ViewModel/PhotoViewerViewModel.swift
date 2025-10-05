import Foundation

final class PhotoViewerViewModel: PhotoViewerViewModelProtocol {
    
    // MARK: - Callbacks
    
    var onDeletePhoto: (() -> Void)?
    var onEmptyPhotoLibrary: (() -> Void)?

    // MARK: - Properties
    
    var photos: [PhotoModel] = []
    
    let strings: PhotoViewerStrings
    var selectedPhotoIndex: Int
    private let photoManager: PhotoManagerProtocol
    
    // MARK: - Init
    
    init(strings: PhotoViewerStrings, selectedPhotoIndex: Int,
         photoManager: PhotoManagerProtocol = PhotoManager.shared) {
        self.strings = strings
        self.selectedPhotoIndex = selectedPhotoIndex
        self.photoManager = photoManager
        self.photos = self.photoManager.loadPhotos()
    }
    
    // MARK: - Main Flow
    
    func newPhotoData(_ direction: Direction) -> Data? {
        updatePhotoIndex(direction)
        return selectedPhotoData()
    }
        
    func selectedPhotoData() -> Data? {
        guard photos.indices.contains(selectedPhotoIndex) else { return nil }
        return photos[selectedPhotoIndex].data
    }
    
    func updatePhotoIndex(_ direction: Direction) {
        switch direction {
        case .left:
            selectedPhotoIndex -= 1
            if selectedPhotoIndex < 0 {
                selectedPhotoIndex = photos.count - 1
            }
        case .right:
            selectedPhotoIndex += 1
            if selectedPhotoIndex > photos.count - 1 {
                selectedPhotoIndex = 0
            }
        }
    }
    
    func deletePhoto() {
        photoManager.deletePhoto(at: selectedPhotoIndex)
        if photoManager.loadPhotos().count == 0 { onEmptyPhotoLibrary?() }
        selectedPhotoIndex = min(selectedPhotoIndex, photos.count - 1)
        photos = photoManager.loadPhotos()
        onDeletePhoto?()
    }
}
