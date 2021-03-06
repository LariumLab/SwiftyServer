import Foundation

public struct Master: Codable{
    public let salonID: UUID
    public let masterID: UUID
    public let services: [Service]?
    public let name: String
    public let schedule: [Day]?
    
    public init(salonID: UUID, masterID: UUID, services: [Service]?, name: String, schedule: [Day]?){
        self.salonID = salonID
        self.masterID = masterID
        self.services = services
        self.name = name
        self.schedule = schedule
    }
}

public struct Day: Codable{
    public var masterID: UUID?
    public let name: String
    public let isDayOff: Bool
    public let startTime: String
    public let endTime: String
    public let order: Int
    
    public init(masterID: UUID?, name: String, isDayOff: Bool, startTime: String, endTime: String, order: Int){
        self.masterID = masterID
        self.name = name
        self.isDayOff = isDayOff
        self.startTime = startTime
        self.endTime = endTime
        self.order = order
    }
}
