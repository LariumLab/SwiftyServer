import Foundation

public struct ServiceToMaster: Codable{
    public let salonID: UUID
    public let serviceID: UUID
    public let masterID: UUID
    
    public init (salonID: UUID, serviceID: UUID, masterID: UUID){
        self.salonID = salonID
        self.serviceID = serviceID
        self.masterID = masterID
    }
}
