import Foundation

public struct Appointment: Codable{
    public let salonID: UUID
    public let serviceID: UUID
    public let masterID: UUID
    public let clientID: UUID
    public let approved: Bool
    public let date: Date
    
    public init(salonID: UUID, serviceID: UUID, masterID: UUID, clientID: UUID, approved: Bool, date: Date){
        self.salonID = salonID
        self.serviceID = serviceID
        self.masterID = masterID
        self.clientID = clientID
        self.approved = approved
        self.date = date
    }
}




