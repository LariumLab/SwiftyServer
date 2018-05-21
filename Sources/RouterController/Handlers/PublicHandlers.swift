import Foundation
import Kitura
import PerfectCRUD
import PerfectPostgreSQL
import Classes

extension Controller{
    
//************************************************************************************************************************//
    
    func getCityList(_ : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        let salonTable = self.dataBase.salonTable
        let salonValues = try salonTable.order(by: \.city).where(\Salon.city != "").select()
        var citySet: [String] = []
        for salon in salonValues{
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
        let salonValues = try salonTable.where(\Salon.city == city).select()
        var salonSet: [SalonPreview] = []
        for salon in salonValues{
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
        guard let salonID = request.queryParameters["salonID"], salonID != "",
              let salonUUID = UUID(uuidString: salonID)
        else{
                try response.status(.badRequest).end()
                return
        }
        let salonTable = self.dataBase.salonTable
        let salonQuery = salonTable.where(\Salon.salonID == salonUUID)
        guard let salon = try salonQuery.first() else{
            try response.status(.badRequest).end()
            return
        }
        let salonInfo = SalonInfo(nickName: salon.nickName, phoneNumber: salon.phoneNumber, description: salon.description)
        try response.status(.OK).send(salonInfo).end()
    }
    
//************************************************************************************************************************//
    
    func getSalonServices(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonID = request.queryParameters["salonID"], salonID != "",
              let salonUUID = UUID(uuidString: salonID)
        else{
            try response.status(.badRequest).end()
            return
        }
        let serviceTable = self.dataBase.serviceTable
        let serviceQuery = serviceTable.where(\Service.salonID == salonUUID)
        var services: [Service] = []
        let serviceValues = try serviceQuery.select()
        for service in serviceValues{
            services.append(service)
        }
        try response.status(.OK).send(services).end()
    }

//************************************************************************************************************************//
    
    func getServiceMasters(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let serviceID = request.queryParameters["serviceID"], serviceID != "",
              let serviceUUID = UUID(uuidString: serviceID)
        else{
            try response.status(.badRequest).end()
            return
        }
        let idTable = self.dataBase.serviceToMasterTable
        let idQuery = idTable.where(\ServiceToMaster.serviceID == serviceUUID)
        let idValues = try idQuery.select()
        let masterTable = self.dataBase.masterTable
        let dayTable = self.dataBase.dayTable
        var masters: [Master] = []
        for masterToService in idValues{
            let masterValues = try masterTable.where(\Master.masterID == masterToService.masterID).select()
            for master in masterValues{
                var schedule: [Day] = []
                let scheduleValues = try dayTable.order(by: \.order).where(\Day.masterID == master.masterID).select()
                for day in scheduleValues{
                    schedule.append(day)
                }
                let newMaster = Master(salonID: master.salonID, masterID: master.masterID, services: nil, name: master.name, schedule: schedule)
                masters.append(newMaster)
            }
        }
        try response.status(.OK).send(masters).end()
    }
    
//************************************************************************************************************************//
    
    func getSalonMasters(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonID = request.queryParameters["salonID"], salonID != "",
              let salonUUID = UUID(uuidString: salonID)
        else{
                try response.status(.badRequest).end()
                return
        }
        let masterTable = self.dataBase.masterTable
        let masterQuery = masterTable.where(\Master.salonID == salonUUID)
        var masters: [Master] = []
        let masterValues = try masterQuery.select()
        let dayTable = self.dataBase.dayTable
        for master in masterValues{
            var schedule: [Day] = []
            let scheduleValues = try dayTable.order(by: \.order).where(\Day.masterID == master.masterID).select()
            for day in scheduleValues{
                schedule.append(day)
            }
            let newMaster = Master(salonID: master.salonID, masterID: master.masterID, services: nil, name: master.name, schedule: schedule)
            masters.append(newMaster)
        }
        try response.status(.OK).send(masters).end()
    }
    
//************************************************************************************************************************//
    
    func getMasterInfo(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let masterID = request.queryParameters["masterID"], masterID != "",
              let masterUUID = UUID(uuidString: masterID)
        else{
            try response.status(.badRequest).end()
            return
        }
        let masterTable = self.dataBase.masterTable
        let masterQuery = masterTable.where(\Master.masterID == masterUUID)
        guard let master = try masterQuery.first() else{
            try response.status(.badRequest).end()
            return
        }
        let dayTable = self.dataBase.dayTable
        var schedule: [Day] = []
        let scheduleValues = try dayTable.order(by: \.order).where(\Day.masterID == master.masterID).select()
        for day in scheduleValues{
            schedule.append(day)
        }
        let newMaster = Master(salonID: master.salonID, masterID: master.masterID, services: nil, name: master.name, schedule: schedule)
        try response.status(.OK).send(newMaster).end()
    }
    
//************************************************************************************************************************//

    func getSalonImage(request : RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let salonID = request.queryParameters["salonID"], salonID != "",
            let salonUUID = UUID(uuidString: salonID)
            else{
                try response.status(.badRequest).end()
                return
        }
        let salonTable = self.dataBase.salonTable
        let salonQuery = salonTable.where(\Salon.salonID == salonUUID)
        guard let salon = try salonQuery.first() else{
            try response.status(.badRequest).end()
            return
        }
        let redirect = "/files/images/" + salon.nickName + ".jpg"
        try response.redirect(redirect).end()
        // rework pls
    }
    
//************************************************************************************************************************//

}
