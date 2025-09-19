import UIKit

final class CollectionViewCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    private var childCoordinators: [CoordinatorProtocol] = []
    private let collectionViewModel = CollectionViewModel(strings: CollectionViewStrings())
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator flow
    
    func start() {
        let collectionViewController = CollectionViewController(viewModel: collectionViewModel)
        collectionViewController.coordinator = self
        navigationController.setViewControllers([collectionViewController], animated: true)
    }
    
    func showAddPhotoFlow() {
        let addPhotoCoordinator = AddPhotoCoordinator(navigationController: navigationController,
                                                      collectionViewModel: collectionViewModel)
        childCoordinators.append(addPhotoCoordinator)
        addPhotoCoordinator.parentCoordinator = self
        addPhotoCoordinator.start()
    }
    
    func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
}
