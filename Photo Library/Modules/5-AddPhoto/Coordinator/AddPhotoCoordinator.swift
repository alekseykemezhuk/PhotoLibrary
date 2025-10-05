import UIKit

final class AddPhotoCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var parentCoordinator: CollectionViewCoordinator?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Flow
    
    func start() {
        let strings = AddPhotoStrings()
        let viewModel = AddPhotoViewModel(strings: strings)
        let viewController = AddPhotoViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishFlow() {
        parentCoordinator?.removeChildCoordinator(self)
        navigationController.popViewController(animated: true)
    }
    
}
