import Foundation

protocol AddPhotoViewModelProtocol: AnyObject {
    var onPhotoSaved: (() -> Void)? { get set }
    var strings: AddPhotoStrings { get }
    func savePhoto(imageData: Data)
    func isCameraPermissionGranted() -> Bool
}
