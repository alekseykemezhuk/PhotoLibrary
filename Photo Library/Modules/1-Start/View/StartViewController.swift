import UIKit
import SnapKit

final class StartViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let signUpButton = UIButton(configuration: .filled())
    
    // MARK: - Properties
    
    weak var coordinator: StartCoordinator?
    private let viewModel: StartViewModelProtocol
    private let layout = Layout.self
    
    // MARK: - Init
    
    init(viewModel: StartViewModelProtocol) {
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
    }
    
    // MARK: - Setup methods
    
    private func setupHierarchy() {
        view.addSubview(signUpButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        signUpButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(safeArea).inset(layout.doubleOffset)
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        signUpButton.setTitle(viewModel.signUpButtonTitle, for: .normal)
        signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpButton.titleLabel?.minimumScaleFactor = 0.5
        signUpButton.titleLabel?.lineBreakMode = .byClipping
        signUpButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    private func setupActions() {
        signUpButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.showSignUpFlow()
        }, for: .touchUpInside)
    }
}
