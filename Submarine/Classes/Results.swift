import Foundation

class Results: Codable {
    var name: String
    var score: Int
    var gameDate: String
    
    init(name: String, score: Int, gameDate: String) {
        self.name = name
        self.score = score
        self.gameDate = gameDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case score
        case gameDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.score, forKey: .score)
        try container.encode(self.gameDate, forKey: .gameDate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.score = try container.decode(Int.self, forKey: .score)
        self.gameDate = try container.decode(String.self, forKey: .gameDate)
    }
}
