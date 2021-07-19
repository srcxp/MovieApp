import UIKit

struct Movies: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    var imageURL : String
    var title : String
    var description : String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "poster_path"
        case title = "original_title"
        case description = "overview"
    }
}
