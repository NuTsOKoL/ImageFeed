import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage, perPage: 10) else {
            print("Failed to make photos request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let newPhotos):
                addToPhotos(newPhotos: newPhotos)
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
            case .failure(let error): print(error)
            }
            self.task = nil
            self.lastLoadedPage = nextPage
        }
        self.task = task
        task.resume()
    }
    
    private func makePhotosRequest(page: Int, perPage: Int) -> URLRequest? {
        guard let baseURL = URL(string: Constants.defaultBaseURL) else { return nil }
        guard let token = OAuth2TokenStorage().token else { return nil }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = "/photos"
        
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        components?.queryItems = queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    private func addToPhotos(newPhotos: [PhotoResult]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        for photo in newPhotos {
            let newPhoto = Photo(
                id: photo.id,
                size: CGSize(width: photo.width, height: photo.height),
                createdAt: dateFormatter.date(from: photo.createdAt),
                welcomeDescription: photo.description,
                thumbImageURL: photo.urls.thumb,
                largeImageURL: photo.urls.full,
                isLiked: photo.likedByUser
            )
            photos.append(newPhoto)
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void?, Error>) -> Void) {
        guard let token = OAuth2TokenStorage().token else { return }
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos/\(photoId)/like") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        urlSession.data(for: request) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // Поиск индекса элемента
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked = isLike
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
    
    func cleanPhotos() {
        photos = []
    }
}

