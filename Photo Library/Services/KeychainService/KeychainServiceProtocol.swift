protocol KeychainServiceProtocol: AnyObject {
    func set(_ value: String, for key: String)
    func get(_ key: String) -> String?
}
