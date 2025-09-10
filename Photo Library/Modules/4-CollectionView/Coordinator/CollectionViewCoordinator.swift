import UIKit

final class CollectionViewCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    private var childCoordinators: [CoordinatorProtocol] = []
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator flow
    
    func start() {
        let strings = CollectionViewStrings()
        let viewModel = CollectionViewModel(strings: strings)
        let collectionViewController = CollectionViewController(viewModel: viewModel)
        collectionViewController.coordinator = self
        navigationController.setViewControllers([collectionViewController], animated: true)
    }
    
    func showAddPhotoFlow() {
        let addPhotoCoordinator = AddPhotoCoordinator(navigationController: navigationController)
        childCoordinators.append(addPhotoCoordinator)
        addPhotoCoordinator.parentCoordinator = self
        addPhotoCoordinator.start()
    }
    
}
