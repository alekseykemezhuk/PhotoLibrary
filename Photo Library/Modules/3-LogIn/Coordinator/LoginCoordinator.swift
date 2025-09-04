import UIKit

final class LoginCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    weak var parentCoordinator: AppCoordinator?
    var navigationController: UINavigationController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator flow
    
    func start() {
        let strings = LoginStrings()
        let viewModel = LoginViewModel(strings: strings)
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func didFinishLogin() {
        parentCoordinator?.didFinishStartFlow(self)
    }
    
    func didResetPassword() {
        parentCoordinator?.didResetPassword(self)
    }
}
