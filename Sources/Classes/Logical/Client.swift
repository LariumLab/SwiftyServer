import Foundation

public struct Client: Codable{
    public let clientID: UUID
    public let phoneNumber: String
    public let name: String
    public let token: String
    
    public init(clientID: UUID, phoneNumber: String, name: String, token: String){
        self.clientID = clientID
        self.phoneNumber = phoneNumber
        self.name = name
        self.token = token
    }
}
