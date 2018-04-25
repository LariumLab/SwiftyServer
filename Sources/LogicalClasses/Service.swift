import Foundation

public struct Service: Codable{
    public var salonID : UUID
    public var serviceID : UUID
    public var name : String
    public var description: String
    public var masters : [Master]?
    public var priceFrom : String
    public var priceTo : String
    
    public init(salonID: UUID, serviceID: UUID, name: String, description: String, masters: [Master]?, priceFrom: String, priceTo: String){
        self.salonID = salonID
        self.serviceID = serviceID
        self.name = name
        self.description = description
        self.masters = masters
        self.priceFrom = priceFrom
        self.priceTo = priceTo
    }
}
