import UIKit
import SnapKit

final class PhotoViewerViewController: UIViewController {
    
    //MARK: - UI Elements
    
    private var mainStackView = UIStackView()
    private let upperButtonsStack = ButtonsStackView()
    private let imageView = UIImageView()
    private let bottomButtonsStack = ButtonsStackView()
    
    //MARK: - Properties
    
    weak var coordinator: PhotoViewerCoordinator?
    private var viewModel: PhotoViewerViewModelProtocol
    private let layout = Layout.self
        
    // MARK: - Init
    
    init(viewModel: PhotoViewerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupAppearance()
        setupActions()
        bindViewModel()
    }
    
    //MARK: - Setup methods
    
    private func setupHierarchy() {
        mainStackView = UIStackView(arrangedSubviews: [upperButtonsStack, imageView, bottomButtonsStack])
        view.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let stackViewSpacing = layout.stackViewSpacing
        let buttonsStackMultiplier = layout.buttonsStackMultiplier
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        
        upperButtonsStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(stackViewSpacing)
            make.height.equalTo(mainStackView.snp.height).multipliedBy(buttonsStackMultiplier)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        bottomButtonsStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(stackViewSpacing)
            make.height.equalTo(mainStackView.snp.height).multipliedBy(buttonsStackMultiplier)
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = layout.stackViewSpacing
        mainStackView.distribution = .fill
        
        upperButtonsStack.setupButtonsAppearance(firstButtonTitle: viewModel.strings.backButtonTitle,
                                                 secondButtonTitle: viewModel.strings.deleteButtonTitle)
        
        imageView.image = UIImage(data: viewModel.selectedPhotoData() ?? Data())
        imageView.contentMode = .scaleAspectFit
        
        bottomButtonsStack.setupButtonsAppearance(firstButtonTitle: viewModel.strings.leftButtonTitle,
                                                  secondButtonTitle: viewModel.strings.rightButtonTitle)
        bottomButtonsStack.setButtonsEnabled(viewModel.photos.count > 1)
    }
    
    private func setupActions() {
        upperButtonsStack.firstButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didFinishFlow()
        }, for: .touchUpInside)
        
        upperButtonsStack.secondButton.addAction(UIAction { [weak self] _ in
            self?.showDeleteAlert()
        }, for: .touchUpInside)
        
        bottomButtonsStack.firstButton.addAction(UIAction { [weak self] _ in
            self?.navigateToPhoto(.left)
        }, for: .touchUpInside)
        
        bottomButtonsStack.secondButton.addAction(UIAction { [weak self] _ in
            self?.navigateToPhoto(.right)
        }, for: .touchUpInside)
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {
        viewModel.onEmptyPhotoLibrary = { [weak self] in
            self?.coordinator?.didFinishFlow()
        }
        
        viewModel.onDeletePhoto = { [weak self] in
            self?.updateUIAfterDeletion()
        }
    }
    
    // MARK: - Flow methods
    
    private func showDeleteAlert() {
        let deleteAction = UIAlertAction(title: viewModel.strings.deleteButtonTitle,
                                         style: .destructive) { [weak self] _ in
            self?.viewModel.deletePhoto()
        }
        
        let cancelAction = UIAlertAction(title: viewModel.strings.cancelActionTitle,
                                         style: .cancel)
        
        showAlert(title: viewModel.strings.deletePhotoTitle,
                  actions: [deleteAction, cancelAction],
                  preferredStyle: .actionSheet)
    }
    
    private func navigateToPhoto(_ direction: Direction) {
        guard let newPhotoData = viewModel.newPhotoData(direction) else { return }
        let newPhoto = UIImage(data: newPhotoData)
        
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve,
                          animations: { self.imageView.image = newPhoto })
    }
    
    private func updateUIAfterDeletion() {
        navigateToPhoto(.left)
        bottomButtonsStack.setButtonsEnabled(viewModel.photos.count > 1)
    }
}

