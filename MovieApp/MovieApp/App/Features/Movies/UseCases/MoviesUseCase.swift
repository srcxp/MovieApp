class MoviesUseCase: MoviesUseCaseProtocol {
    
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchSearchMovies(
        category: MovieCategoryViewModel,
        completion: @escaping (Result<[MovieSearchModel], Error>) -> Void
    ) {
        repository.fetchMovies(categoryModel: .popular, subcategoryModel: .action) {
            (result: Result<[MovieRepositoryModel], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                let useCaseSearchModels: [MovieSearchModel] = value.map { model -> MovieSearchModel in
                    let imageUrl = NetworkConstants.imagePath + model.imageUrl
                    return MovieSearchModel(
                        id: model.id,
                        imageUrl: imageUrl,
                        title: model.title,
                        description: model.description)
                }
                completion(.success(useCaseSearchModels))
            }
        }
    }
    
    func fetchMovies(
        categoryViewModel: MovieCategoryViewModel,
        subcategoryViewModel: SubcategoryViewModel,
        completion: @escaping (Result<[MovieModel], Error>) -> Void
    ) {
        guard
            let subcategoryModel = SubcategoryModel(from: subcategoryViewModel),
            let categoryModel = MovieCategoryModel(from: categoryViewModel)
        else {
            return
        }
        
        repository.fetchMovies(categoryModel: categoryModel, subcategoryModel: subcategoryModel) {
            (result: Result<[MovieRepositoryModel], Error>)  in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let repoModels):
                let useCaseModels: [MovieModel] = repoModels.map { model -> MovieModel in
                    let subcategoryModels = model.subcategories.compactMap { SubcategoryModel(rawValue: $0.rawValue) }
                    let imageUrl = NetworkConstants.imagePath + model.imageUrl
                    return MovieModel(
                        id: model.id,
                        imageUrl: imageUrl,
                        isSelected: false,
                        subcategories: subcategoryModels)
                }
                var filteredValue = [MovieModel]()
                switch categoryViewModel {
                case .popular, .topRated:
                    filteredValue = useCaseModels.filter({
                        $0.subcategories.contains(subcategoryModel)
                    })
                default:
                    filteredValue = useCaseModels
                }
                completion(.success(filteredValue))
            }
        }
    }
    
    func fetchMovie(
        with id: Int,
        completion: @escaping (Result<MovieDetailsModel, Error>) -> Void
    ) {
        repository.fetchMovie(with: id) { [weak self]
            (result: Result<MovieDetailsRepositoryModel, Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let value):
                let posterUrl = NetworkConstants.imagePath + value.posterPath
                let progressPercentage = value.voteAverage * 10
                let movieDetailsModels: MovieDetailsModel = MovieDetailsModel(
                    posterPath: posterUrl,
                    voteAverage: progressPercentage,
                    title: value.title,
                    releaseDate: value.releaseDate,
                    runtime: value.runtime,
                    language: value.language,
                    genres: self?.mapGenresToModels(from: value.genres) ?? [],
                    overview: value.overview)
                completion(.success(movieDetailsModels))
            }
        }
    }
    
    func fetchActors(
        with id: Int,
        completion: @escaping (Result<[ActorModel], Error>) -> Void
    ) {
        repository.fetchActors(with: id) { (result: Result<[ActorRepositoryModel], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let model):
                let actorsModels = model.map { repoModels -> ActorModel in
                    return ActorModel(from: repoModels)
                }
                let actors = actorsModels.filter { model in
                    model.deparment.elementsEqual("Acting")
                }
                let topActors = actors[0..<10]
                completion(.success(Array(topActors)))
            }
        }
    }
    
    
    private func mapGenresToModels(from repositoryModels: [GenresRepositoryModel]) -> [GenresModel] {
        repositoryModels.map { GenresModel(from: $0) }
    }
    
}


