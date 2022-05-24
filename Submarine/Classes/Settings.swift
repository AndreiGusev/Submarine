import Foundation

class Settings: Codable {
    
    var submarine: Int  // sumarine color
    var speed = 1   // game speed
    var name: String
    var fish : Bool
    var torpeda : Bool
    var ship : Bool
    
    init(submarine: Int, speed: Int, name: String, fish: Bool, torpeda: Bool, ship: Bool) {
        self.submarine = submarine
        self.speed = speed
        self.name = name
        self.fish = fish
        self.torpeda = torpeda
        self.ship = ship
    }
    
    private enum CodingKeys: String, CodingKey {
        case submarine
        case speed
        case name
        case fish
        case torpeda
        case ship
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.submarine, forKey: CodingKeys.submarine)
        try container.encode(self.speed, forKey: CodingKeys.speed)
        try container.encode(self.name, forKey: CodingKeys.name)
        try container.encode(self.fish, forKey: CodingKeys.fish)
        try container.encode(self.torpeda, forKey: CodingKeys.torpeda)
        try container.encode(self.ship, forKey: CodingKeys.ship)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.submarine = try container.decode(Int.self, forKey: .submarine)
        self.speed = try container.decode(Int.self, forKey: .speed)
        self.name = try container.decode(String.self, forKey: .name)
        self.fish = try container.decode(Bool.self, forKey: .fish)
        self.torpeda = try container.decode(Bool.self, forKey: .torpeda)
        self.ship = try container.decode(Bool.self, forKey: .ship)
    }
    
}
