import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let photoName: [String] = Array(0...20).map {( "\($0)") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
    }
}
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) { }
}
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

