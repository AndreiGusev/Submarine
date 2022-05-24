import UIKit
import RxCocoa
import RxSwift
import Foundation

//MARK: - class
class RxScoreViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel = RxTableViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - IBoutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.localize()
    }
    
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureTableView() {
        viewModel
            .dataSource
            .bind(to: tableView
                .rx
                .items(cellIdentifier: RxResultsTableViewCell.identifier,
                       cellType: RxResultsTableViewCell.self)) {index, model, cell in
                cell.configure(with: (model.name), score: (model.score), gameDate: (model.gameDate))
            }
                       .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .subscribe { indexPath in
                guard let index = indexPath.element else { return }
                self.tableView.deselectRow(at: index, animated: true)
                print(self.viewModel.dataSource.value[index.row])
            }
        
            .disposed(by: disposeBag)
    }
    
    func localize() {
        let backButton = "Back".localized
        self.backButton.setTitle(backButton,
                                 for: .normal)
        
        let scoreTable = "Score Table".localized
        self.scoreLabel.text = scoreTable
    }
    
}


