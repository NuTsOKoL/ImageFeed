@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {
    func testViewControllerCallsFetchPhotosNextPage() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testCellHeight() {
        //given
        let presenter = ImagesListPresenter()
        presenter.photos = [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: nil,
                welcomeDescription: nil,
                thumbImageURL: "https://image.com/1",
                largeImageURL: "https://image.com/2",
                isLiked: false
            )
        ]
        
        //when
        let cellHeight = presenter.getCellHeight(100, 0)
        
        //then
        XCTAssertEqual(cellHeight, 76)
    }
}
