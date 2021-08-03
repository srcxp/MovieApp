import UIKit

class MainInfoView: UIView {
    
    let defaultOffset = 18
    let secondaryOffset = 8
    let progressBarTopOffset = 107
    
    var moviePoster: UIImageView!
    var progressBar: UIImageView!
    var progressLabel: UILabel!
    var userScoreLabel: UILabel!
    var nameLabel: UILabel!
    var releaseDateLabel: UILabel!
    var genresAndDurationLabel: UILabel!
    var elipseImageView: UIImageView!
    var favoriteImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
