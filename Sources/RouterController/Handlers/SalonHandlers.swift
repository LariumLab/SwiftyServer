import Foundation
import Kitura
import PerfectCRUD
import PerfectPostgreSQL
import Classes
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
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let query = salonTable.where(\Salon.token == token)
        if (try query.count() != 1){
            try response.status(.forbidden).end()
            return
        }
        guard let body = request.body,
              let json = body.asJSON,
              let salonInfo = try? JSONDecoder().decode(SalonInfo.self, from: JSON(json).rawData())
        else{
            try response.status(.badRequest).end()
            return
        }
        let newSalon = Salon(customName: salonInfo.customName, phoneNumber: salonInfo.phoneNumber, description: salonInfo.description, city: salonInfo.city, address: salonInfo.address)
        try query.update(newSalon, setKeys: \.customName, \.phoneNumber, \.description, \.city, \.address)
        try response.status(.OK).end()
    }
    
//************************************************************************************************************************//
    
    fileprivate struct ServiceInfo: Codable{
        let name : String
        let description: String
        let priceFrom : String
        let priceTo : String
    }
    
    func postSalonAddService(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let token = request.queryParameters["token"], token != "" else{
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let query = salonTable.where(\Salon.token == token)
        if (try query.count() != 1){
            try response.status(.forbidden).end()
            return
        }
        let values = try query.select()
        for salon in values{
            let salonID = salon.salonID
            guard let body = request.body,
                let json = body.asJSON,
                let serviceInfo = try? JSONDecoder().decode(ServiceInfo.self, from: JSON(json).rawData())
                else{
                    try response.status(.badRequest).end()
                    return
            }
            let newService = Service(salonID: salonID, serviceID: UUID(), masters: nil, name: serviceInfo.name, description: serviceInfo.description, priceFrom: serviceInfo.priceFrom, priceTo: serviceInfo.priceTo)
            let serviceTable = self.dataBase.serviceTable
            try serviceTable.insert(newService)
        }
        try response.status(.OK).end()
    }
    
//************************************************************************************************************************//
    
    fileprivate struct MasterInfo: Codable{
        let name : String
        let schedule: [Day]
    }
    
    func postSalonAddNewMasterToService(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let token = request.queryParameters["token"], token != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let serviceID = request.queryParameters["serviceID"], serviceID != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let serviceUUID = UUID(uuidString: serviceID) else{
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let query = salonTable.where(\Salon.token == token)
        if (try query.count() != 1){
            try response.status(.forbidden).end()
            return
        }
        let values = try query.select()
        for salon in values{
            let salonID = salon.salonID
            guard let body = request.body,
                let json = body.asJSON,
                let masterInfo = try? JSONDecoder().decode(MasterInfo.self, from: JSON(json).rawData())
                else{
                    try response.status(.badRequest).end()
                    return
            }
            let newMaster = Master(salonID: salonID, masterID: UUID(), services: nil, name: masterInfo.name, schedule: masterInfo.schedule)
            let masterTable = self.dataBase.masterTable
            try masterTable.insert(newMaster)
            let serviceToMasterTable = self.dataBase.serviceToMasterTable
            try serviceToMasterTable.insert(ServiceToMaster(salonID: salonID,serviceID: serviceUUID,masterID: newMaster.masterID))
        }
        try response.status(.OK).end()
        
    }
    
//************************************************************************************************************************//
    
    func postSalonAddExistingMasterToService(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let token = request.queryParameters["token"], token != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let serviceID = request.queryParameters["serviceID"], serviceID != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let serviceUUID = UUID(uuidString: serviceID) else{
            try response.status(.badRequest).end()
            return
        }
        guard let masterID = request.queryParameters["masterID"], masterID != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let masterUUID = UUID(uuidString: masterID) else{
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let query = salonTable.where(\Salon.token == token)
        if (try query.count() != 1){
            try response.status(.forbidden).end()
            return
        }
        let values = try query.select()
        for salon in values{
            let salonID = salon.salonID
            let serviceToMasterTable = self.dataBase.serviceToMasterTable
            let masterTable = self.dataBase.masterTable
            let checkQuery = try masterTable.join(\.services, with: ServiceToMaster.self, on: \.masterID, equals: \.serviceID, and: \.serviceID, is: \.serviceID).where(\Master.masterID == masterUUID)
            if (try checkQuery.count() != 0){
                try response.status(.badRequest).end()
                return
            }
            else{
                try serviceToMasterTable.insert(ServiceToMaster(salonID: salonID, serviceID: serviceUUID, masterID: masterUUID))
            }
        }
        try response.status(.OK).end()
    }
    
//************************************************************************************************************************//
        
    
    
    
}
