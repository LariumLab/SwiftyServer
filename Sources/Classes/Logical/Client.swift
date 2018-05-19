import Foundation

public struct Client: Codable{
    public let clientID: UUID
    public let login: String
    public let token: String
    public let phoneNumber: String
    
    public init(clientID: UUID, login: String, token: String, phoneNumber: String){
        self.clientID = clientID
        self.login = login
        self.token = token
        self.phoneNumber = phoneNumber
    }
}
