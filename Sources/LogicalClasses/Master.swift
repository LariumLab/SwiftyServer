import Foundation

public struct Master: Codable{
    public let salonID: UUID
    public let name: String
    public let services: [Service]?
//    public let schedule: [Day]
    
    public init(salonID: UUID, name: String, services: [Service]?){
        self.salonID = salonID
        self.name = name
        self.services = services
    }
}

