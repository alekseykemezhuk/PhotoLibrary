import UIKit

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Manager.shared.imageArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
          
        let array = Manager.shared.imageArray()
        cell.configure(with: array[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = Manager.shared.imageArray()[indexPath.item]
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageScrollViewController") as? ImageScrollViewController else { return }
        controller.selectedImage = selectedImage
        controller.imageIndex = indexPath.item
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width) / 2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CollectionViewController: AddPhotoViewControllerDelegate {
    
    func vcWasClosed() {
        collectionView.reloadData()
    }
}

extension CollectionViewController: ImageScrollViewControllerDelegate {
    
    func imageWasDeleted() {
        collectionView.reloadData()
    }
}
