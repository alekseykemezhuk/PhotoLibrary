protocol CollectionViewModelProtocol: AnyObject {
    var onUpdatePasswordSuccess: (() -> Void)? { get set }
    var onUpdatePasswordError: (() -> Void)? { get set }
    var strings: CollectionViewStrings { get }
    func updatePassword(_ newPassword: String)
}
