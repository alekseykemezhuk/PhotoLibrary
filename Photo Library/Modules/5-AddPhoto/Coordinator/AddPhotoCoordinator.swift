import UIKit

final class AddPhotoCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var parentCoordinator: CollectionViewCoordinator?
    private let collectionViewModel: CollectionViewModelProtocol
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, collectionViewModel: CollectionViewModelProtocol) {
        self.navigationController = navigationController
        self.collectionViewModel = collectionViewModel
    }
    
    // MARK: - Coordinator Flow
    
    func start() {
        let strings = AddPhotoStrings()
        let viewModel = AddPhotoViewModel(strings: strings)
        viewModel.onPhotoSaved = { [weak self] image in
            self?.collectionViewModel.addPhoto(image)
            self?.didFinishAddPhotoFlow()
        }
        let viewController = AddPhotoViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinishAddPhotoFlow() {
        parentCoordinator?.removeChildCoordinator(self)
        navigationController.popViewController(animated: true)
    }
    
}
