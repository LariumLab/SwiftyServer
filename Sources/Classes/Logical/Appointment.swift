import Foundation

public struct Appointment: Codable{
    public let salonID: UUID
    public let serviceID: UUID
    public let masterID: UUID
    public let clientID: UUID
    public let approved: Bool
    public let startDate: String
    public let endDate: String
    
    public let clientPhoneNumber: String
    public let salonName: String
    public let salonAddress: String
    public let serviceName: String
    public let price: String
    
    public init(salonID: UUID,
                serviceID: UUID,
                masterID: UUID,
                clientID: UUID,
                approved: Bool,
                startDate: String,
                endDate: String,
                clientPhoneNumber: String,
                salonName: String,
                salonAddress: String,
                serviceName: String,
                price: String)
    {
        self.salonID = salonID
        self.serviceID = serviceID
        self.masterID = masterID
        self.clientID = clientID
        self.approved = approved
        self.startDate = startDate
        self.endDate = endDate
        
        self.clientPhoneNumber = clientPhoneNumber
        self.salonName = salonName
        self.salonAddress = salonAddress
        self.serviceName = serviceName
        self.price = price
    }
}




