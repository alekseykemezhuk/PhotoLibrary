import UIKit

protocol ImageScrollViewControllerDelegate: AnyObject {
    func imageWasDeleted()
}

enum Direction {
    case left
    case right
}

class ImageScrollViewController: UIViewController {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: - Properties
    
    weak var delegate: ImageScrollViewControllerDelegate?
    var selectedImage = UIImage()
    var imageIndex = Int()
    var imageArray = Manager.shared.imageArray()
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsStateHandle()
        imageView.image = selectedImage
    }

    //MARK: - @IBActions
     
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "You can't restore it later", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) {_ in
            var imagesUrlArray = UserDefaults.standard.value([Images].self, forKey: "images")
            imagesUrlArray?.remove(at: self.imageIndex)
            UserDefaults.standard.set(encodable: imagesUrlArray, forKey: "images")
            self.imageArray.remove(at: self.imageIndex)
            if self.imageArray.count == 0 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.imageChangeHandle(direction: .right)
            }
            self.delegate?.imageWasDeleted()
        }
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        if scrollView.zoomScale > 1.0 {
            UIView.animate(withDuration: 0.1) {
                self.scrollView.zoomScale = 1.0
            } completion: { _ in
                self.imageChangeHandle(direction: .left)
            }
        } else {
            imageChangeHandle(direction: .left)
        }
    }
    
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        if scrollView.zoomScale > 1.0 {
            UIView.animate(withDuration: 0.1) {
                self.scrollView.zoomScale = 1.0
            } completion: { _ in
                self.imageChangeHandle(direction: .right)
            }
        } else {
            imageChangeHandle(direction: .right)
        }
    }
    
    //MARK: - Flow methods

    private func buttonsStateHandle() {
        if imageArray.count - 1 == 0 {
            leftButton.isEnabled = false
            rightButton.isEnabled = false
        } else {
            leftButton.isEnabled = true
            rightButton.isEnabled = true
        }
    }
    
    private func imageChangeHandle(direction: Direction) {
        
        switch direction {
            
        case .left:
            if imageIndex == 0 {
                imageIndex = imageArray.count
            }
            leftButton.isEnabled = false
            rightButton.isEnabled = false
            let secondImageView = UIImageView(frame: CGRect(x: -view.frame.width, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height))
            secondImageView.contentMode = .scaleAspectFit
            secondImageView.backgroundColor = .black
            secondImageView.image = imageArray[imageIndex - 1]
            view.addSubview(secondImageView)
            UIView.animate(withDuration: 0.3) {
                secondImageView.frame.origin.x = self.scrollView.frame.origin.x
            } completion: { _ in
                self.imageView.image = self.imageArray[self.imageIndex - 1]
                secondImageView.removeFromSuperview()
                self.buttonsStateHandle()
                self.imageIndex -= 1
            }
            
        case .right:
            if imageIndex >= imageArray.count - 1 {
                imageIndex = -1
            }
            leftButton.isEnabled = false
            rightButton.isEnabled = false
            let secondImageView = UIImageView(frame: CGRect(x: view.frame.width, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: scrollView.frame.height))
            secondImageView.contentMode = .scaleAspectFit
            secondImageView.backgroundColor = .black
            secondImageView.image = imageArray[imageIndex + 1]
            view.addSubview(secondImageView)
            UIView.animate(withDuration: 0.3) {
                secondImageView.frame.origin.x = self.scrollView.frame.origin.x
            } completion: { _ in
                self.imageView.image = self.imageArray[self.imageIndex + 1]
                secondImageView.removeFromSuperview()
                self.buttonsStateHandle()
                self.imageIndex += 1
            }
        }
    }
    
}

