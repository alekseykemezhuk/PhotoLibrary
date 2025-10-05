import UIKit

final class StartCoordinator: CoordinatorProtocol {

    // MARK: - Properties
    
    weak var parentCoordinator: AppCoordinator?
    var navigationController: UINavigationController
    private var childCoordinators: [CoordinatorProtocol] = []

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator flow

    func start() {
        let strings = StartStrings()
        let viewModel = StartViewModel(strings: strings)
        let viewController = StartViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showSignUpFlow() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.parentCoordinator = self
        signUpCoordinator.start()
    }
    
    func didFinishSignUp(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
        parentCoordinator?.didFinishStartFlow(self)
    }
}
