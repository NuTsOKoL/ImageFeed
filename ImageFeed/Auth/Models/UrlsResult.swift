import Foundation

struct UrlsResult {
    let thumbImageURL: String
    let largeImageURL: String

    private enum CodingKeys: String, CodingKey {
        case thumbImageURL = "https://images.unsplash.com/"
        case largeImageURL = " "
    }
}


