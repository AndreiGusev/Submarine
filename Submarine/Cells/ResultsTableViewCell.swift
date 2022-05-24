import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func configure(with name: String, score: Int, gameDate: String) {
        self.name.text = "\(name)"
        self.score.text = "\(score)"
        self.date.text = "\(gameDate)"
    }
    
}
