import Foundation

struct FavoriteResponseDTO: Decodable {
    let isFavorited: Bool

    enum CodingKeys: String, CodingKey {
        case isFavorited = "is_favorited"
    }
}