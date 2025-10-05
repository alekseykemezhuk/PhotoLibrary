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
    
    func showPhotoViewerFlow(selectedPhotoIndex: Int) {
        let photoViewerCoordinator = PhotoViewerCoordinator(navigationController: navigationController,
                                                            selectedPhotoIndex: selectedPhotoIndex)
        childCoordinators.append(photoViewerCoordinator)
        photoViewerCoordinator.parentCoordinator = self
        photoViewerCoordinator.start()
    }
    
    func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
}
