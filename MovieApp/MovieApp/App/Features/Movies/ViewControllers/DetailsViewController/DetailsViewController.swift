import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    let defaultOffset = 20
    let defaultInset = 18
    let recommendationsCollectionViewHeight = 114
    let castCollectionViewHeight = 106
    let actorsCollectionViewHeight = 259
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var mainInfoView: MainInfoView!
    var overviewView: OverviewView!
    var castView: CastView!
    var actorsView: ActorsView!
    var socialView: SocialView!
    var recommendationView: RecommendationsView!
    
    var presenter: DetailsPresenter!
    private var disposables = Set<AnyCancellable>()

    convenience init(presenter: DetailsPresenter) {
        self.init()
        
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        styleNavigationBar()
        presenter.setDelegate(delegate: self)
        mainInfoView.setDelegate(delegate: self)
        bindViews()
    }
    
    func setActorsData(model: [ActorViewModel]) {
        actorsView.setData(with: model)
    }
    
    func setCastData(model: [CastViewModel]) {
        castView.setData(with: model)
    }
    
    func setReviewData(model: SocialViewModel) {
        socialView.setData(with: model)
    }
    
    func setRecommendationsData(model: [RecommendationsViewModel]) {
        recommendationView.setData(with: model)
    }
    
    func favoritePressed() {
        presenter.updateFavoriteMovie()
    }
    
    func hideReview() {
        socialView.postTitle.text = LocalizableStrings.noReview.rawValue
        socialView.postInfo.text = LocalizableStrings.tryAgain.rawValue
        socialView.logoImage.image = UIImage(with: .noReview)
    }
    
    private func bindViews() {
        presenter
            .detailsData
            .sink {_ in }
                receiveValue: { self.mainInfoView.setData(with: $0.info)
                    self.overviewView.setData(with: $0.overview)
                }
            .store(in: &disposables)
    }
    
    private func styleNavigationBar() {
        let logo = UIImage(with: .appLogo)
        let logoImageView = UIImageView()
        logoImageView.image = logo
        navigationItem.titleView = logoImageView
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(with: .backButton),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func backButtonPressed(){
        presenter.popToHomeScreen()
    }

}
