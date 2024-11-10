import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadRequestCalled: Bool = false
    var presenter: (any ImageFeed.WebViewPresenterProtocol)?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float, animated: Bool) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
}
