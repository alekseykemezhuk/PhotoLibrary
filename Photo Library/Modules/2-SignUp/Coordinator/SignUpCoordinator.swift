import UIKit

final class SignUpCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    weak var parentCoordinator: StartCoordinator?
    var navigationController: UINavigationController
    
    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator flow

    func start() {
        let strings = SignUpStrings()
        let viewModel = SignUpViewModel(strings: strings)
        let viewController = SignUpViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func didFinishSignUp() {
        parentCoordinator?.didFinishSignUp(self)
    }
    
}
