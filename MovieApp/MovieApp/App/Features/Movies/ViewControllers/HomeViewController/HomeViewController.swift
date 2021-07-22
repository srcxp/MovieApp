import UIKit

class HomeViewController: UIViewController {
    
    let defaultInset = 20
    
    var logoImageView: UIImageView!
    var searchBarStackView: SearchBarStackView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        buildNavigationBar()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uiViewPressed))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func uiViewPressed(){
        view.endEditing(true)
    }
}


extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier) as? CategoryCell
        else {
            return UITableViewCell()
        }

        return cell
    }
    
}
