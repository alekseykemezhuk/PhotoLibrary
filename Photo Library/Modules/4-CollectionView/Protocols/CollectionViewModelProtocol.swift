import UIKit
protocol CollectionViewModelProtocol: AnyObject {
    var onPhotosUpdated: (() -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    var onUpdatePasswordSuccess: (() -> Void)? { get set }
    var onUpdatePasswordError: (() -> Void)? { get set }
    var photos: [UIImage] { get }
    var strings: CollectionViewStrings { get }
    func loadPhotos()
    func addPhoto(_ image: UIImage)
    func deletePhoto(at index: Int)
    func updatePassword(_ newPassword: String)
}
