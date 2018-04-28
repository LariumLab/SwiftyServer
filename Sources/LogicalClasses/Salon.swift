import Foundation

 public struct Salon : Codable{
    public let salonID: UUID
    public let nickName: String
    public let customName: String
    public let phoneNumber: String
    public let description: String
    public let city: String
    public let address: String
    public let token: String
    
    public let services: [Service]?
    public let masters: [Master]?
    public let appointments: [Appointment]?
    
    public init(salonID: UUID = UUID(), nickName: String = "", customName: String = "", phoneNumber: String = "", description: String = "", city: String = "", address: String = "", token: String = "", services: [Service]? = nil, masters: [Master]? = nil, appointments: [Appointment]? = nil){
        self.salonID = salonID
        self.nickName = nickName
        self.customName = customName
        self.phoneNumber = phoneNumber
        self.description = description
        self.city = city
        self.address = address
        self.token = token
        self.services = services
        self.masters = masters
        self.appointments = appointments
    }
}
