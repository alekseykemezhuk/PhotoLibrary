import Foundation

protocol PhotoViewerViewModelProtocol: AnyObject {
    var onDeletePhoto: (() -> Void)? { get set }
    var onEmptyPhotoLibrary: (() -> Void)? { get set }
    var photos: [PhotoModel] { get }
    var strings: PhotoViewerStrings { get }
    var selectedPhotoIndex: Int { get }
    func selectedPhotoData() -> Data?
    func newPhotoData(_ direction: Direction) -> Data?
    func deletePhoto()
}
