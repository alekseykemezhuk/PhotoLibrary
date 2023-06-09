import UIKit

class Images: Codable {
    
    var imageArray : String
    
    init(imageArray: String) {
        self.imageArray = imageArray
    }
    
    public enum CodingKeys: String, CodingKey {
        case imageArray
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.imageArray = try container.decode(String.self, forKey: .imageArray)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.imageArray, forKey: .imageArray)
    }
}

