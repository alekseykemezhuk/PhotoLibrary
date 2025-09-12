import UIKit
import SnapKit

final class CollectionViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var mainStackView = UIStackView()
    private var buttonsStackView = ButtonsStackView()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Properties
    
    weak var coordinator: CollectionViewCoordinator?
    private let viewModel: CollectionViewModelProtocol
    private let layout = Layout.self
    
    // MARK: - Init
    
    init(viewModel: CollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupAppearance()
        setupActions()
        bindViewModel()
    }
    
    // MARK: - Setup methods
    
    private func setupHierarchy() {
        mainStackView = UIStackView(arrangedSubviews: [collectionView, buttonsStackView])
        view.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(layout.stackViewSpacing)
            make.height.equalTo(mainStackView.snp.height).multipliedBy(layout.buttonsStackMultiplier)
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = layout.stackViewSpacing
        mainStackView.distribution = .fill
        
        buttonsStackView.setupButtonsAppearance(firstButtonTitle: viewModel.strings.changePasswordButtonTitle,
                                                secondButtonTitle: viewModel.strings.addButtonTitle)
    }
    
    private func setupActions() {
        buttonsStackView.firstButton.addAction(UIAction { [weak self] _ in
            self?.showChangePasswordAlert()
        }, for: .touchUpInside)
        
        buttonsStackView.secondButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.showAddPhotoFlow()
        }, for: .touchUpInside)
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        viewModel.onUpdatePasswordSuccess = { [weak self] in
            self?.showAlert(title: self?.viewModel.strings.passwordChangeSuccessTitle ?? "",
                            message: self?.viewModel.strings.passwordChangeSuccessMessage ?? "")
        }
        
        viewModel.onUpdatePasswordError = { [weak self] in
            self?.showAlert(title: self?.viewModel.strings.passwordChangeErrorTitle ?? "",
                            message: self?.viewModel.strings.passwordChangeErrorMessage ?? "",
                            actions: [UIAlertAction(title: self?.viewModel.strings.okActionTitle,
                                                    style: .default) { [weak self] _ in
                self?.showChangePasswordAlert()
            }])
        }
    }
    
    // MARK: - Private methods
    
    private func showChangePasswordAlert() {
        showTextFieldAlert(
            title: viewModel.strings.changePasswordAlertTitle,
            message: viewModel.strings.changePasswordAlertMessage,
            placeholder: viewModel.strings.newPasswordPlaceholder,
            isSecure: true,
            confirmTitle: viewModel.strings.saveActionTitle,
            cancelTitle: viewModel.strings.cancelActionTitle
        ) { [weak self] newPassword in
            self?.viewModel.updatePassword(newPassword)
        }
    }
}
