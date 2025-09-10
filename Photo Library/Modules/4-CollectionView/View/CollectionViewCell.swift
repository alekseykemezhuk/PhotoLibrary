import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    func configure(with image: UIImage?) {
        imageView.image = image 
    }
}
