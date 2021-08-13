class MoviesRepository: MoviesRepositoryProtocol {
    
    private let networkDataSource: MoviesNetworkDataSourceProtocol
    
    init(networkDataSource: MoviesNetworkDataSourceProtocol) {
        self.networkDataSource = networkDataSource
    }
    
    func fetchMovies(
        categoryModel: MovieCategoryModel,
        subcategoryModel: SubcategoryModel,
        completion: @escaping (Result<[MovieRepositoryModel], Error>) -> Void
    ) {
        guard
            let categoryRepoModel = MovieCategoryRepositoryModel(from: categoryModel),
            let subcategoryRepoModel = SubcategoryRepositoryModel(from: subcategoryModel)
        else {
            return
        }
        
        networkDataSource.fetchMovies(
            categoryRepositoryModel: categoryRepoModel,
            subcategoryRepositoryModel: subcategoryRepoModel
        ) {
            (result: Result<[MovieDataSourceModel], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                let repositoryModels: [MovieRepositoryModel] = value.map { model -> MovieRepositoryModel in
                    let subcategories = model.subcategories.compactMap {
                        SubcategoryRepositoryModel(from: $0)
                    }
                    return MovieRepositoryModel(
                        id: model.id,
                        imageUrl: model.imageUrl,
                        title: model.title,
                        description: model.description,
                        subcategories: subcategories)
                }
                completion(.success(repositoryModels))
            }
        }
    }
    
    func fetchMovie(
        with id: Int,
        completion: @escaping (Result<MovieDetailsRepositoryModel, Error>) -> Void
    ) {
        networkDataSource.fetchMovie(with: id) {
            (result: Result<MovieDetailsDataSourceModel, Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                let movieDetailsRepositoryModels = MovieDetailsRepositoryModel(
                    from: value,
                    genres: value.genres
                )
                completion(.success(movieDetailsRepositoryModels))
            }
        }
    }
    
    func fetchActors(
        with id: Int,
        completion: @escaping (Result<[ActorRepositoryModel], Error>) -> Void
    ) {
        networkDataSource.fetchActors(with: id) { (result: Result<[ActorDataSourceModel], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let model):
                let actorsRepositoryModels = model.map {
                    ActorRepositoryModel(from: $0)
                }
                completion(.success(actorsRepositoryModels))
            }
        }
    }
    
    func fetchReviews(
        with id: Int,
        completion: @escaping (Result<[ReviewRepositoryModel], Error>) -> Void
    ) {
        networkDataSource.fetchReviews(with: id) { (result: Result<[ReviewDataSourceModel], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let model):
                let reviewsRepositoryModels = model.map { dataSourceModel in
                    ReviewRepositoryModel(from: dataSourceModel)
                }
                completion(.success(reviewsRepositoryModels))
            }
        }
    }
    
    func fetchRecommendations(
        with id: Int,
        completion: @escaping (Result<[RecommendationRepositoryModel], Error>) -> Void
    ) {
        
        networkDataSource.fetchRecommendations(with: id) { (result: Result<[RecommendationDataSourceModel], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let model):
                let recommendationsRepositoryModels = model.map {
                    RecommendationRepositoryModel(from: $0)
                }
                completion(.success(recommendationsRepositoryModels))
            }
        }
    }

}
