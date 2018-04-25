import Foundation
import Kitura
import PerfectCRUD
import PerfectPostgreSQL
import LogicalClasses

extension Controller{
    func getCityList(_ : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        let salonTable = self.dataBase.salonTable
        let values = try salonTable.order(by: \.city).select()
        var citySet: [String] = []
        for salon in values{
            if ((citySet.count == 0) || (salon.city != citySet.last)){
                citySet.append(salon.city)
            }
        }
        try response.status(.OK).send(citySet).end()
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
    ////////////////////////undone
    func getSalonServices(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonName = request.queryParameters["salonName"], salonName != "" else{
            try response.status(.badRequest).end()
            return
        }
        try response.status(.OK).end()
    }
    
    func getServiceMasters(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonName = request.queryParameters["salonName"], salonName != "",
            let serviceName = request.queryParameters["serviceName"], serviceName != ""
            else{
                try response.status(.badRequest).end()
                return
        }
        try response.status(.OK).end()
    }
    
    func getMasterInfo(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonName = request.queryParameters["salonName"], salonName != "",
            let masterName = request.queryParameters["masterName"], masterName != ""
            else{
                try response.status(.badRequest).end()
                return
        }
        try response.status(.OK).end()
    }
    
    func getMasterSchedule(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonName = request.queryParameters["salonName"], salonName != "",
            let masterName = request.queryParameters["masterName"], masterName != ""
            else{
                try response.status(.badRequest).end()
                return
        }
        try response.status(.OK).end()
    }
}

