import Foundation

final class PhotoManager: PhotoManagerProtocol {
    
    // MARK: - Properties
    
    static let shared = PhotoManager()
    
    private let userDefaultsKey = "photoKey"
    private let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Save
    
    func savePhoto(_ data: Data) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        let url = directory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: url)
            appendKey(fileName)
            return fileName
        } catch {
            print("Error saving image:", error)
            return nil
        }
    }
    
    // MARK: - Load
    
    func loadPhotos() -> [PhotoModel] {
        let keys = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        return keys.compactMap { fileName in
            let url = directory.appendingPathComponent(fileName)
            guard let data = try? Data(contentsOf: url) else { return nil }
            return PhotoModel(fileName: fileName, data: data)
        }
    }
    
    // MARK: - Delete
    
    func deletePhoto(at index: Int) {
        var keys = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        guard index < keys.count else { return }
        
        let fileName = keys[index]
        let url = directory.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
        
        keys.remove(at: index)
        UserDefaults.standard.set(keys, forKey: userDefaultsKey)
    }
    
    // MARK: - Delete All
    
    func deleteAllPhotos() {
        let keys = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        for fileName in keys {
            let url = directory.appendingPathComponent(fileName)
            try? FileManager.default.removeItem(at: url)
        }
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    // MARK: - Helpers
    
    private func appendKey(_ fileName: String) {
        var keys = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        keys.append(fileName)
        UserDefaults.standard.set(keys, forKey: userDefaultsKey)
    }
}
