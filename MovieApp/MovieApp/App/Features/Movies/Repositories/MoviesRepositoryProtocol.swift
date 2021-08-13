protocol MoviesRepositoryProtocol {
    
    func fetchMovies(
        categoryModel: MovieCategoryModel,
        subcategoryModel: SubcategoryModel,
        completion: @escaping (Result<[MovieRepositoryModel], Error>) -> Void
    )
    
    func fetchMovie(
        with id: Int,
        completion: @escaping (Result<MovieDetailsRepositoryModel, Error>) -> Void
    )
    
    func fetchActors(
        with id: Int,
        completion: @escaping (Result<[ActorRepositoryModel], Error>) -> Void
    )
    
}
