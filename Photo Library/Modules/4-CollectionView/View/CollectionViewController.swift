import UIKit
import SnapKit

final class CollectionViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var mainStackView = UIStackView()
    private var buttonsStackView = ButtonsStackView()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    
    weak var coordinator: CollectionViewCoordinator?
    private let photoManager: PhotoManagerProtocol
    private let viewModel: CollectionViewModelProtocol
    private let layout = Layout.self
    
    // MARK: - Init
    
    init(viewModel: CollectionViewModelProtocol,
         photoManager: PhotoManagerProtocol = PhotoManager.shared) {
        self.viewModel = viewModel
        self.photoManager = photoManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupAppearance()
        setupActions()
        setupCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPhotos()
    }
    
    // MARK: - Setup methods
    
    private func setupHierarchy() {
        mainStackView = UIStackView(arrangedSubviews: [collectionView, buttonsStackView])
        view.addSubview(mainStackView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(layout.stackViewSpacing)
            make.height.equalTo(mainStackView.snp.height).multipliedBy(layout.buttonsStackMultiplier)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = layout.stackViewSpacing
        mainStackView.distribution = .fill
        
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.backgroundColor = .black
        
        buttonsStackView.setupButtonsAppearance(firstButtonTitle: viewModel.strings.changePasswordButtonTitle,
                                                secondButtonTitle: viewModel.strings.addButtonTitle)
        
        activityIndicator.color = .white
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupActions() {
        buttonsStackView.firstButton.addAction(UIAction { [weak self] _ in
            self?.showChangePasswordAlert()
        }, for: .touchUpInside)
        
        buttonsStackView.secondButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.showAddPhotoFlow()
        }, for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {
        viewModel.onPhotosUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isActive in
            isActive ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
        
        viewModel.onPasswordUpdated = { [weak self] in
            self?.showAlert(title: self?.viewModel.strings.passwordChangeSuccessTitle ?? "",
                            message: self?.viewModel.strings.passwordChangeSuccessMessage ?? "")
        }
        
        viewModel.onPasswordUpdateFailed = { [weak self] in
            self?.showAlert(title: self?.viewModel.strings.passwordChangeErrorTitle ?? "",
                            message: self?.viewModel.strings.passwordChangeErrorMessage ?? "",
                            actions: [UIAlertAction(title: self?.viewModel.strings.okActionTitle,
                                                    style: .default) { _ in
                self?.showChangePasswordAlert()
            }])
        }
    }
    
    // MARK: - Private methods
    
    private func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let collectionViewlayout = UICollectionViewFlowLayout()
        let itemSpacing = layout.collectionViewItemSpacing
        let numberOfColumns = layout.collectionViewColumns
        collectionViewlayout.minimumLineSpacing = itemSpacing
        collectionViewlayout.minimumInteritemSpacing = itemSpacing
        let side = (view.frame.width - (numberOfColumns - 1)) / numberOfColumns
        collectionViewlayout.itemSize = CGSize(width: side, height: side)
        return collectionViewlayout
    }
    
    private func showChangePasswordAlert() {
        showTextFieldAlert(
            title: viewModel.strings.changePasswordAlertTitle,
            message: viewModel.strings.changePasswordAlertMessage,
            placeholder: viewModel.strings.newPasswordPlaceholder,
            isSecure: true,
            confirmTitle: viewModel.strings.saveActionTitle,
            cancelTitle: viewModel.strings.cancelActionTitle
        ) { [weak self] newPassword in
            self?.viewModel.updatePassword(newPassword)
        }
    }
}

    // MARK: - Extensions

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showPhotoViewerFlow(selectedPhotoIndex: indexPath.row)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                            for: indexPath) as? CollectionViewCell
        else { return UICollectionViewCell() }
        let imageData = viewModel.photos[indexPath.row].data
        let image = UIImage(data: imageData)
        cell.configure(with: image)
        return cell
    }
    
    
}
