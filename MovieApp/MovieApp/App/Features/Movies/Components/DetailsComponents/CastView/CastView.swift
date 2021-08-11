import UIKit

class CastView: UIView {
    
    let defaultOffset = 18
    let secondaryOffset = 7
    let collectionViewHeight = 249
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 125, height: 209)
        layout.minimumInteritemSpacing = 12
        return layout
    }()
    
    var title: UILabel!
    var fullCastButton: UIButton!
    var collectionView: UICollectionView!
    
    var castViewModel = [CastCollectionViewModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(model: MovieDetailsViewModel) {
        castViewModel = model.actors
    }
}

extension CastView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.reuseIdentifier,
                for: indexPath) as? CastCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.setData(model: castViewModel[indexPath.row])
        return cell
    }
    
}
