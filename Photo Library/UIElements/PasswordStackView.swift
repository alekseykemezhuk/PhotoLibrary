import UIKit
import SnapKit

final class PasswordStackView: UIStackView {

    private let label = UILabel()
    let textField = UITextField()
    let actionButton = UIButton(configuration: .filled())
    private let layout = Layout.self
    private let fonts = Fonts.self
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addArrangedSubview(label)
        addArrangedSubview(textField)
        addArrangedSubview(actionButton)
    }
    
    private func setupConstraints() {
        let defaultOffset = layout.defaultOffset
        let doubleOffset = layout.doubleOffset

        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(defaultOffset)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(defaultOffset)
        }
        
        actionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(doubleOffset)
        }
    }
    
    func setupAppearance(labelText: String, textFieldPlaceHolderText: String, actionButtonTitleText: String) {
        alignment = .center
        axis = .vertical
        spacing = layout.stackViewSpacing
        distribution = .fillEqually
        
        label.textColor = .white
        label.text = labelText
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = fonts.titleFont
        
        textField.placeholder = textFieldPlaceHolderText
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        
        actionButton.setTitle(actionButtonTitleText, for: .normal)
        actionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        actionButton.titleLabel?.lineBreakMode = .byClipping
        actionButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }

}
