import Foundation
import Kitura
import PerfectCRUD
import PerfectPostgreSQL
import LogicalClasses
import CryptoSwift

extension Controller{
    // registration
    func postSalonRegistration(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let nickName = request.queryParameters["nickName"], nickName != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let password = request.queryParameters["password"], password != "" else{
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let query = salonTable.where(\Salon.nickName == nickName)
        if (try query.count() != 0){
            try response.status(.conflict).end()
            return
        }
        let salt = "SwiftyServer"
        let tokenString = nickName + salt + password
        let token = tokenString.md5()
        let salon = Salon(salonID: UUID(), nickName: nickName, token: token, services: nil, masters: nil, appointments: nil)
        try salonTable.insert(salon)
        try response.status(.OK).send(token).end()
    }
    
    //
    
}
