import UIKit

final class PhotoViewerCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var parentCoordinator: CollectionViewCoordinator?
    private let selectedPhotoIndex: Int
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, selectedPhotoIndex: Int) {
        self.navigationController = navigationController
        self.selectedPhotoIndex = selectedPhotoIndex
    }
    
    // MARK: - Coordinator Flow
    
    func start() {
        let strings = PhotoViewerStrings()
        let viewModel = PhotoViewerViewModel(strings: strings, selectedPhotoIndex: selectedPhotoIndex)
        let viewController = PhotoViewerViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishFlow() {
        parentCoordinator?.removeChildCoordinator(self)
        navigationController.popViewController(animated: true)
    }
}
