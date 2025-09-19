import UIKit

protocol AddPhotoViewModelProtocol: AnyObject {
    var onPhotoSaved: ((UIImage) -> Void)? { get set }
    var strings: AddPhotoStrings { get }
    func savePhoto(_ image: UIImage)
    func isCameraPermissionGranted() -> Bool
}
