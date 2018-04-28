import Foundation
import Kitura
import PerfectCRUD
import PerfectPostgreSQL
import LogicalClasses
import CryptoSwift
import SwiftyJSON

extension Controller{

//************************************************************************************************************************//
    
    func postSalonSignUp(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
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
        let salon = Salon(nickName: nickName, token: token)
        try salonTable.insert(salon)
        try response.status(.OK).send(token).end()
    }
    
//************************************************************************************************************************//
    
    func postSalonSignIn(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
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
        if (try query.count() != 1){
            try response.status(.badRequest).end()
            return
        }
        let salt = "SwiftyServer"
        let tokenString = nickName + salt + password
        let token = tokenString.md5()
        let values = try query.select()
        for salon in values{
            if (salon.token == token){
                try response.status(.OK).send(token).end()
            }else{
                try response.status(.badRequest).end()
            }
        }
    }
    
//************************************************************************************************************************//
   
    fileprivate struct SalonInfo: Codable{
        let customName: String
        let phoneNumber: String
        let description: String
        let city: String
        let address: String
    }
    
    func postSalonInfo(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let token = request.queryParameters["token"], token != "" else{
            try response.status(.badRequest).send("no token").end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let query = salonTable.where(\Salon.token == token)
        if (try query.count() != 1){
            try response.status(.badRequest).send("bad token").end()
            return
        }
        guard let body = request.body,
              let json = body.asJSON,
              let info = try? JSONDecoder().decode(SalonInfo.self, from: JSON(json).rawData())
        else{
            try response.status(.badRequest).send("Bad json").end()
            return
        }
        let newSalon = Salon(customName: info.customName, phoneNumber: info.phoneNumber, description: info.description, city: info.city, address: info.address)
        try query.update(newSalon, setKeys: \.customName, \.phoneNumber, \.description, \.city, \.address)
        try response.status(.OK).end()
    }
    
}
