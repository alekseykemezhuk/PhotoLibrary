protocol CollectionViewModelProtocol: AnyObject {
    var onPhotosUpdated: (() -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    var onPasswordUpdated: (() -> Void)? { get set }
    var onPasswordUpdateFailed: (() -> Void)? { get set }
    var photos: [PhotoModel] { get }
    var strings: CollectionViewStrings { get }
    func loadPhotos()
    func isNeededReloadData() -> Bool
    func updatePassword(_ newPassword: String)
}
