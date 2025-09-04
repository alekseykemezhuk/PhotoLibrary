import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    //MARK: - UI Elements
    
    private let resetPasswordButton = UIButton(configuration: .plain())
    private var passwordStackView = PasswordStackView()

    //MARK: - Properties
    
    weak var coordinator: LoginCoordinator?
    private let viewModel: LoginViewModelProtocol
    private let layout = Layout.self
    
    // MARK: - Init
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupAppearance()
        setupActions()
        bindViewModel()
    }
    
    //MARK: - Setup methods
    
    private func setupHierarchy() {
        view.addSubview(resetPasswordButton)
        view.addSubview(passwordStackView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let keyboardLayout = view.keyboardLayoutGuide
        let defaultOffset = layout.defaultOffset
        let quaterOffset = layout.quaterOffset
        
        resetPasswordButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(safeArea).inset(quaterOffset)
        }
        
        passwordStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeArea)
            make.bottom.equalTo(keyboardLayout.snp.top).offset(-defaultOffset)
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        
        resetPasswordButton.setTitle(viewModel.strings.resetButtonTitle, for: .normal)
        resetPasswordButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resetPasswordButton.titleLabel?.lineBreakMode = .byClipping
        resetPasswordButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        passwordStackView.setupAppearance(labelText: viewModel.strings.enterPasswordLabel,
                                          textFieldPlaceHolderText: viewModel.strings.textFieldPlaceHolder,
                                          actionButtonTitleText: viewModel.strings.actionButtonTitle)
    }
    
    private func setupActions() {
        resetPasswordButton.addAction(UIAction { [weak self] _ in
            self?.showResetPasswordAlert()
        }, for: .touchUpInside)
        
        passwordStackView.textField.delegate = self
        
        passwordStackView.actionButton.addAction(UIAction { [weak self] _ in
            self?.didTapLogin()
        }, for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    
    private func bindViewModel() {
        viewModel.onLogInSuccess = { [weak self] in
            self?.coordinator?.didFinishLogin()
        }
        viewModel.onLogInError = { [weak self] in
            self?.showInvalidLoginAlert()
        }
        viewModel.onResetPassword = { [weak self] in
            self?.coordinator?.didResetPassword()
        }
    }
    
    private func didTapLogin() {
        guard let password = passwordStackView.textField.text else { return }
        viewModel.didTapLogin(password)
    }
    
    private func showInvalidLoginAlert() {
        let alertTitle = viewModel.strings.errorAlertTitle
        let alertMessage = viewModel.strings.errorAlertMessage
        let alertActionTitle = viewModel.strings.errorAlertOkButtonTitle
        let alertAction = UIAlertAction(title: alertActionTitle, style: .default) { [weak self] _ in
            self?.passwordStackView.textField.text = ""
        }
        showAlert(title: alertTitle, message: alertMessage, actions: [alertAction])
    }
    
    private func showResetPasswordAlert() {
        let alertTitle = viewModel.strings.resetAlertTitle
        let alertMessage = viewModel.strings.resetAlertMessage
        let alertActionTitle = viewModel.strings.resetAlertOkButtonTitle
        let alertOkAction = UIAlertAction(title: alertActionTitle,
                                          style: .destructive) { [weak self] _ in
            self?.viewModel.resetPassword()
        }
        let alertCancelAction = UIAlertAction(title: viewModel.strings.resetAlertCancelButtonTitle,
                                              style: .cancel)
        showAlert(title: alertTitle, message: alertMessage, actions: [alertOkAction, alertCancelAction])
    }
}

    // MARK: - Extensions

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
