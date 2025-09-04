import UIKit
import SnapKit
import KeychainSwift

final class SignUpViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var passwordStackView = PasswordStackView()
    
    // MARK: - Properties
    
    weak var coordinator: SignUpCoordinator?
    private let viewModel: SignUpViewModelProtocol
    private let layout = Layout.self
    
    // MARK: - Init
    
    init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC Lifecycle
    
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
        view.addSubview(passwordStackView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let keyboardLayout = view.keyboardLayoutGuide
        let defaultOffset = layout.defaultOffset
        
        passwordStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeArea)
            make.bottom.equalTo(keyboardLayout.snp.top).offset(-defaultOffset)
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        
        passwordStackView.setupAppearance(labelText: viewModel.strings.createPasswordLabel,
                                          textFieldPlaceHolderText: viewModel.strings.textFieldPlaceHolder,
                                          actionButtonTitleText: viewModel.strings.actionButtonTitle)
    }
    
    private func setupActions() {
        passwordStackView.textField.delegate = self
        
        passwordStackView.actionButton.addAction(UIAction { [weak self] _ in
            self?.didTapSave()
        }, for: .touchUpInside)
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.onSignUpSuccess = { [weak self] in
            self?.coordinator?.didFinishSignUp()
        }
        viewModel.onSignUpError = { [weak self] in
            self?.showErrorAlert()
        }
    }
    
    private func didTapSave() {
        guard let password = passwordStackView.textField.text else { return }
        viewModel.didTapSave(password)
    }
     
    private func showErrorAlert() {
        let alertTitle = viewModel.strings.alertTitle
        let alertMessage = viewModel.strings.alertMessage
        let doneButtonTitle = viewModel.strings.alertDoneButtonTitle
        let doneAction = UIAlertAction(title: doneButtonTitle, style: .default) { [weak self] _ in
            self?.passwordStackView.textField.text = ""
        }
        showAlert(title: alertTitle, message: alertMessage, actions: [doneAction])
    }
}

    // MARK: - Extensions

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
