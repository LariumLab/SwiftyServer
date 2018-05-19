import Foundation
import Kitura
import PerfectCRUD
import PerfectPostgreSQL
import Classes

extension Controller{
    
//************************************************************************************************************************//
    
    func getCityList(_ : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        let salonTable = self.dataBase.salonTable
        let values = try salonTable.order(by: \.city).where(\Salon.city != "").select()
        var citySet: [String] = []
        for salon in values{
            if ((citySet.count == 0) || (salon.city != citySet.last)){
                citySet.append(salon.city)
            }
        }
        try response.status(.OK).send(citySet).end()
    }
    
//************************************************************************************************************************//
    
    fileprivate struct SalonPreview: Codable{
        let customName: String
        let address: String
        let ID: UUID
    }
    
    func getSalonListInCity(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let city = request.queryParameters["city"], city != "" else{
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let values = try salonTable.where(\Salon.city == city).select()
        var salonSet: [SalonPreview] = []
        for salon in values{
            salonSet.append(SalonPreview(customName: salon.customName, address: salon.address, ID: salon.salonID))
        }
        try response.status(.OK).send(salonSet).end()
    }
    
//************************************************************************************************************************//
    
    fileprivate struct SalonInfo: Codable{
        let nickName: String
        let phoneNumber: String
        let description: String
    }
    
    func getSalonInfo(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonID = request.queryParameters["salonID"], salonID != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let salonUUID = UUID(uuidString: salonID) else{
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let query = salonTable.where(\Salon.salonID == salonUUID)
        let queryCount = try query.count()
        if (queryCount == 0){
            try response.status(.badRequest).end()
            return
        }
        if (queryCount > 1){
            try response.status(.internalServerError).end()
            return
        }
        let values = try query.select()
        for salon in values{
            let salonInfo = SalonInfo(nickName: salon.nickName, phoneNumber: salon.phoneNumber, description: salon.description)
            try response.status(.OK).send(salonInfo).end()
        }
    }
    
//************************************************************************************************************************//
    
    func getSalonServices(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonID = request.queryParameters["salonID"], salonID != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let salonUUID = UUID(uuidString: salonID) else{
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.serviceTable
        let query = salonTable.where(\Service.salonID == salonUUID)
        var services: [Service] = []
        let values = try query.select()
        for service in values{
            services.append(service)
        }
        try response.status(.OK).send(services).end()
    }

//************************************************************************************************************************//
    
    func getServiceMasters(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let serviceID = request.queryParameters["serviceID"], serviceID != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let serviceUUID = UUID(uuidString: serviceID) else{
            try response.status(.badRequest).end()
            return
        }
        let masterTable = self.dataBase.masterTable
        let query = try masterTable.join(\.services, with: ServiceToMaster.self, on: \.masterID, equals: \.serviceID, and: \.serviceID, is: \.serviceID).where(\Service.serviceID == serviceUUID)
        let values = try query.select()
        var masters: [Master] = []
        for master in values{
            masters.append(master)
        }
        try response.status(.OK).send(masters).end()
    }
    
//************************************************************************************************************************//
    
    func getSalonMasters(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonID = request.queryParameters["salonID"], salonID != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let salonUUID = UUID(uuidString: salonID) else{
            try response.status(.badRequest).end()
            return
        }
        let masterTable = self.dataBase.masterTable
        let query = masterTable.where(\Master.salonID == salonUUID)
        var masters: [Master] = []
        let values = try query.select()
        for master in values{
            masters.append(master)
        }
        try response.status(.OK).send(masters).end()
    }
    
//************************************************************************************************************************//
    
    func getMasterInfo(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let masterID = request.queryParameters["masterID"], masterID != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let masterUUID = UUID(uuidString: masterID) else{
            try response.status(.badRequest).end()
            return
        }
        let masterTable = self.dataBase.masterTable
        let query = masterTable.where(\Master.masterID == masterUUID)
        let values = try query.select()
        for master in values{
            try response.status(.OK).send(master).end()
        }
    }
    
//************************************************************************************************************************//

}
