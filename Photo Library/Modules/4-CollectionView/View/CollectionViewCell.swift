import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private let imageView = UIImageView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupAppearance()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    
    private func setupHierarchy() {
        self.addSubview(imageView)
    }
    
    private func setupAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    func configure(with image: UIImage?) {
        imageView.image = image 
    }
}
