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
        
        resetPasswordButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(safeArea).inset(layout.quaterOffset)
        }
        
        passwordStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeArea)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-layout.defaultOffset)
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
    
    // MARK: - Bindings
    
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
    
    // MARK: - Private Methods
    
    private func didTapLogin() {
        guard let password = passwordStackView.textField.text else { return }
        viewModel.didTapLogin(password)
    }
    
    private func showInvalidLoginAlert() {
        let alertAction = UIAlertAction(title: viewModel.strings.errorAlertOkButtonTitle,
                                        style: .default) { [weak self] _ in
            self?.passwordStackView.textField.text = ""
        }
        
        showAlert(title: viewModel.strings.errorAlertTitle, message: viewModel.strings.errorAlertMessage,
                  actions: [alertAction])
    }
    
    private func showResetPasswordAlert() {
        let alertOkAction = UIAlertAction(title: viewModel.strings.resetAlertOkButtonTitle,
                                          style: .destructive) { [weak self] _ in
            self?.viewModel.resetPassword()
        }
        
        let alertCancelAction = UIAlertAction(title: viewModel.strings.resetAlertCancelButtonTitle,
                                              style: .cancel)
        
        showAlert(title: viewModel.strings.resetAlertTitle,
                  message: viewModel.strings.resetAlertMessage,
                  actions: [alertOkAction, alertCancelAction])
    }
}

    // MARK: - Extensions

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
