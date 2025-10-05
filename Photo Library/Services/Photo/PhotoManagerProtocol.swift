import Foundation

protocol PhotoManagerProtocol: AnyObject {
    func savePhoto(_ data: Data) -> String?
    func loadPhotos() -> [PhotoModel]
    func deletePhoto(at index: Int)
    func deleteAllPhotos()
}
