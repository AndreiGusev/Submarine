import UIKit

//MARK: - class
class ScoreViewController: UIViewController {
    
    // MARK: - lets/vars
    var resultsList: [Results] = []
    
    // MARK: IBoutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadResults()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.localize()
    }
    
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) {
        saveResult()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - flow funcs
    func saveResult() {
        UserDefaults.standard.set(encodable: resultsList, forKey: "results")
    }
    
    func loadResults() {
        if let results = UserDefaults.standard.value([Results].self, forKey: "results") {
            let sortedResults = results.sorted {
                $0.gameDate > $1.gameDate
            }
            self.resultsList = sortedResults
        }
    }
    
    func localize() {
        let backButton = "Back".localized
        self.backButton.setTitle(backButton,
                                 for: .normal)
        
        let scoreTable = "Score Table".localized
        self.scoreLabel.text = scoreTable
    }
}

// MARK: - extension
extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ _tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return resultsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell") as? ResultsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: resultsList[indexPath.row].name, score: resultsList[indexPath.row].score, gameDate: resultsList[indexPath.row].gameDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                self.resultsList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
            }
        }
    
}
