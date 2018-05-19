import Foundation

public struct Appointment: Codable{
    public let salonID: UUID
    public let serviceID: UUID
    public let masterID: UUID
    public let clientID: UUID
    public let approved: Bool
    public let startDate: String
    public let endDate: String
    
    public init(salonID: UUID, serviceID: UUID, masterID: UUID, clientID: UUID, approved: Bool, startDate: String, endDate: String){
        self.salonID = salonID
        self.serviceID = serviceID
        self.masterID = masterID
        self.clientID = clientID
        self.approved = approved
        self.startDate = startDate
        self.endDate = endDate
    }
}




