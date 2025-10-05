import UIKit
import SnapKit

final class ButtonsStackView: UIStackView {
    
    // MARK: - UI Elements
    
    let firstButton = UIButton(configuration: .gray())
    let secondButton = UIButton(configuration: .gray())
    
    // MARK: - Properties
    
    private let layout = Layout.self
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    
    private func setupHierarchy() {
        addArrangedSubview(firstButton)
        addArrangedSubview(secondButton)
    }
    
    func setupButtonsAppearance(firstButtonTitle: String, secondButtonTitle: String) {
        axis = .horizontal
        alignment = .fill
        spacing = layout.stackViewSpacing
        distribution = .fill
        
        firstButton.setTitle(firstButtonTitle, for: .normal)
        firstButton.titleLabel?.adjustsFontSizeToFitWidth = true
        firstButton.titleLabel?.lineBreakMode = .byClipping
        firstButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        secondButton.setTitle(secondButtonTitle, for: .normal)
        secondButton.titleLabel?.adjustsFontSizeToFitWidth = true
        secondButton.titleLabel?.lineBreakMode = .byClipping
        secondButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    // MARK: - Buttons State
    
    func setButtonsEnabled(_ areEnabled: Bool) {
        firstButton.isEnabled = areEnabled
        secondButton.isEnabled = areEnabled
    }
}
