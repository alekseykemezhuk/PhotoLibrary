import UIKit
import KeychainSwift

final class AppCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties

    var navigationController: UINavigationController
    private var childCoordinators: [CoordinatorProtocol] = []
    private var keychainService: KeychainServiceProtocol
    
    // MARK: - Init

    init(navigationController: UINavigationController,
         keychainService: KeychainServiceProtocol = KeychainService()) {
        self.navigationController = navigationController
        self.keychainService = keychainService
    }
    
    // MARK: - Coordinator flow
    
    func start() {
        if isLoggedIn() {
            showLogin()
        } else {
            showStart()
        }
    }
    
    func didResetPassword(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
        showStart()
    }
    
    func didFinishStartFlow(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
        showCollectionView()
    }
    
    private func isLoggedIn() -> Bool {
        return keychainService.get("password") != nil && keychainService.get("password") != ""
    }
    
    private func showLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.parentCoordinator = self
        loginCoordinator.start()
    }
    
    private func showStart() {
        let startCoordinator = StartCoordinator(navigationController: navigationController)
        childCoordinators.append(startCoordinator)
        startCoordinator.parentCoordinator = self
        startCoordinator.start()
    }
    
    private func showCollectionView() {
        let collectionViewCoordinator = CollectionViewCoordinator(
            navigationController: navigationController)
        childCoordinators.append(collectionViewCoordinator)
        collectionViewCoordinator.start()
    }
}
