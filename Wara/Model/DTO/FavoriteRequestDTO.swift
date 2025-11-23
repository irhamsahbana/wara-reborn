import Foundation

struct FavoriteRequestDTO: Encodable {
    let id: String
    let favoritableType: String

    enum CodingKeys: String, CodingKey {
        case id
        case favoritableType = "favoritable_type"
    }
}