import Foundation

class MoviesNetworkClient: MoviesNetworkClientProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getMovies(
        category: MovieCategoryDataSourceModel,
        subcategory: SubcategoryDataSourceModel,
        completion: @escaping (Result<MoviesNetworkModel, NetworkError>) -> Void
    ) {
        var url: URL?
        switch category {
        case .popular:
            url = EndpointConstant.popularMovies.url
        case .topRated:
            url = EndpointConstant.topRatedMovies.url
        case .trending:
            switch subcategory {
            case .thisWeek:
                url = EndpointConstant.trendingMoviesThisWeek.url
            default:
                url = EndpointConstant.trendingMoviesToday.url
            }
        }

        guard let url = url else { return }

        networkService.get(url: url, completion: completion)
    }
    
}
