import Foundation
import RxSwift
import RxCocoa

class RxTableViewModel {
    
    private var scoreList: [Results] = UserDefaults.standard.value([Results].self, forKey: "results") ?? []
    
    var dataSource = BehaviorRelay<[Results]>(value: [])
    
    init() {
        dataSource.accept(scoreList)
    }
    
}
