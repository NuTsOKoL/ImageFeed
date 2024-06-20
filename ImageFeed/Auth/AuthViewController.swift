import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service()
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        ProgressHUD.animate()
        fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            ProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self, didAuthenticateWithCode: code)
            case .failure(let error):
                print(errorMessage(from: error))
            }
        }
        func errorMessage(from error: Error) -> String {
            switch error {
            case NetworkError.httpStatusCode(let code):
                return "Error \(code) when receiving token."
            default:
                return error.localizedDescription
            }
        }
    }
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
extension AuthViewController {
    private func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        oauth2Service.fetchOAuthToken(with: code) { result in
            completion(result)
        }
    }
}
