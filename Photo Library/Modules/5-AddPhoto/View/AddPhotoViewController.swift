import UIKit
import PhotosUI
import SnapKit

final class AddPhotoViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var mainStackView = UIStackView()
    private let buttonsStackView = ButtonsStackView()
    let imageView = UIImageView()
    
    // MARK: - Properties
    
    weak var coordinator: AddPhotoCoordinator?
    private let layout = Layout.self
    private let viewModel: AddPhotoViewModelProtocol
    
    // MARK: - Init
    
    init(viewModel: AddPhotoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupAppearance()
        setupActions()
        bindViewModel()
        showImagePicker()
    }
    
    // MARK: - Setup methods
    
    private func setupHierarchy() {
        mainStackView = UIStackView(arrangedSubviews: [imageView, buttonsStackView])
        view.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(layout.stackViewSpacing)
            make.height.equalTo(mainStackView.snp.height).multipliedBy(layout.buttonsStackMultiplier)
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFit
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = layout.stackViewSpacing
        mainStackView.distribution = .fill
        
        buttonsStackView.setupButtonsAppearance(firstButtonTitle: viewModel.strings.backButtonTitle,
                                                secondButtonTitle: viewModel.strings.saveButtonTitle)
    }
    
    private func setupActions() {
        buttonsStackView.firstButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didFinishFlow()
        }, for: .touchUpInside)
        
        buttonsStackView.secondButton.addAction(UIAction { [weak self] _ in
            guard let imageData = self?.imageView.image?.pngData() else { return }
            self?.viewModel.savePhoto(imageData: imageData)
        }, for: .touchUpInside)
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {
        viewModel.onPhotoSaved = { [weak self] in
            self?.coordinator?.didFinishFlow()
        }
    }
    
    // MARK: - Private methods
    
    private func showImagePicker() {
        let firstAlertAction = UIAlertAction(title: viewModel.strings.libraryActionTitle,
                                             style: .default) { [weak self] _ in
            self?.showPhotoLibraryPicker()
        }
        
        let secondAlertAction = UIAlertAction(title: viewModel.strings.cameraActionTitle,
                                              style: .default) { [weak self] _ in
            guard let self = self else { return }
            if self.viewModel.isCameraPermissionGranted() {
                self.showCameraPicker()
            } else {
                self.showCameraAccessDeniedAlert()
            }
        }
        
        let cancelAlertAction = UIAlertAction(title: viewModel.strings.cancelActionTitle,
                                              style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        showAlert(title: viewModel.strings.imagePickerTitle,
                  actions: [firstAlertAction, secondAlertAction, cancelAlertAction],
                  preferredStyle: .actionSheet)
    }
    
    private func showPhotoLibraryPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func showCameraPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    private func showCameraAccessDeniedAlert() {
        let alertAction = UIAlertAction(title: viewModel.strings.okActionTitle,
                                        style: .default) { [weak self] _ in
            self?.showImagePicker()
        }
        
        showAlert(title: viewModel.strings.cameraAccessDeniedTitle,
                  message: viewModel.strings.cameraAccessDeniedMessage,
                  actions: [alertAction])
    }
}

    // MARK: - Extensions

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddPhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                self?.imageView.image = image as? UIImage
            }
        }
    }
}


