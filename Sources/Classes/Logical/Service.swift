import Foundation

public struct Service: Codable{
    public let salonID : UUID
    public let serviceID : UUID
    public let masters: [Master]?
    public let name : String
    public let description: String
    public let priceFrom : String
    public let priceTo : String
    
    public init(salonID: UUID, serviceID: UUID, masters: [Master]?, name: String, description: String, priceFrom: String, priceTo: String){
        self.salonID = salonID
        self.serviceID = serviceID
        self.masters = masters
        self.name = name
        self.description = description
        self.priceFrom = priceFrom
        self.priceTo = priceTo
    }
}
