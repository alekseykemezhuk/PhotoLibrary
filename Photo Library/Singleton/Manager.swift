import UIKit
import KeychainSwift

class Manager {
    
    static let shared = Manager()
    
    private init() {}
    
    //MARK: - Properties
    
    let keychain = KeychainSwift()
    let keychainkey = "password"
    
    //MARK: - Flow shared methods
    
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil }
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func imageArray() -> [UIImage] {
        
        var imageArray : [UIImage] = []
        if let imagesUrlArray = UserDefaults.standard.value([Images].self, forKey: "images") {
            for i in imagesUrlArray {
                if let image = loadImage(fileName: i.imageArray) {
                    imageArray.append(image)
                }
            }
        }
        return imageArray
    }
}
