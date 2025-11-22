import Foundation

struct UploadPhotoDTO: Decodable {
    let filename: String
    let url: String
}