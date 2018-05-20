import Foundation
import Kitura
import PerfectPostgreSQL
import PerfectCRUD
import Classes
import CryptoSwift
import SwiftyJSON

extension Controller{

//************************************************************************************************************************//
    
    func postClientSignUp(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let phoneNumber = request.queryParameters["phoneNumber"], phoneNumber != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let name = request.queryParameters["name"], name != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let password = request.queryParameters["password"], password != "" else{
            try response.status(.badRequest).end()
            return
        }
        let clientTable = self.dataBase.clientTable
        let clientQuery = clientTable.where(\Client.phoneNumber == phoneNumber)
        guard try clientQuery.count() == 0 else {
            try response.status(.conflict).end()
            return
        }
        let salt = "SwiftyServer"
        let tokenString = phoneNumber + salt + password
        let token = tokenString.md5()
        let client = Client(clientID: UUID(), phoneNumber: phoneNumber, name: name, token: token)
        try clientTable.insert(client)
        try response.status(.OK).send(token).end()
    }
    
//************************************************************************************************************************//
    
    func postClientSignIn(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let phoneNumber = request.queryParameters["phoneNumber"], phoneNumber != "" else{
            try response.status(.badRequest).end()
            return
        }
        guard let password = request.queryParameters["password"], password != "" else{
            try response.status(.badRequest).end()
            return
        }
        let salt = "SwiftyServer"
        let tokenString = phoneNumber + salt + password
        let token = tokenString.md5()
        let clientTable = self.dataBase.clientTable
        let clientQuery = clientTable.where(\Client.token == token)
        guard try clientQuery.count() == 1 else {
            try response.status(.badRequest).end()
            return
        }
        try response.status(.OK).send(token).end()
    }
    
//************************************************************************************************************************//
    
    fileprivate struct ClientAppointment: Codable{
        let salonID: UUID
        let serviceID: UUID
        let masterID: UUID
        let startDate: String
    }
    
    func postClientMakeAppointment(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let token = request.queryParameters["token"], token != "" else{
            try response.status(.badRequest).end()
            return
        }
        let clientTable = self.dataBase.clientTable
        let clientQuery = clientTable.where(\Client.token == token)
        guard let client = try clientQuery.first() else{
            try response.status(.badRequest).end()
            return
        }
        guard let body = request.body,
              let json = body.asJSON,
              let app = try? JSONDecoder().decode(ClientAppointment.self, from: JSON(json).rawData())
        else{
            try response.status(.badRequest).end()
            return
        }
        let salonTable = self.dataBase.salonTable
        let salonQuery = salonTable.where(\Salon.salonID == app.salonID)
        guard let salon = try salonQuery.first() else{
            try response.status(.badRequest).end()
            return
        }
        let serviceTable = self.dataBase.serviceTable
        let serviceQuery = serviceTable.where(\Service.serviceID == app.serviceID)
        guard let service = try serviceQuery.first() else{
            try response.status(.badRequest).end()
            return
        }
        let newApp = Appointment(salonID: app.salonID,
                                 serviceID: app.serviceID,
                                 masterID: app.masterID,
                                 clientID: client.clientID,
                                 approved: false,
                                 startDate: app.startDate,
                                 endDate: "",
                                 clientPhoneNumber: client.phoneNumber,
                                 salonName: salon.customName,
                                 salonAddress: salon.address,
                                 serviceName: service.name,
                                 price: "")
        let appointmentTable = self.dataBase.appointmentTable
        try appointmentTable.insert(newApp)
        try response.status(.OK).end()
    }
    
//************************************************************************************************************************//
    
    func getClientCheckAppointments(request: RouterRequest, response: RouterResponse, _ : @escaping () -> Void) throws {
        guard let token = request.queryParameters["token"], token != "" else{
            try response.status(.badRequest).end()
            return
        }
        let clientTable = self.dataBase.clientTable
        let clientQuery = clientTable.where(\Client.token == token)
        guard let client = try clientQuery.first() else{
            try response.status(.badRequest).end()
            return
        }
        let appointmentTable = self.dataBase.appointmentTable
        let appQuery = appointmentTable.where(\Appointment.clientID == client.clientID)
        var appointmets: [Appointment] = []
        let appValues = try appQuery.select()
        for app in appValues{
            appointmets.append(app)
        }
        try response.status(.OK).send(appointmets).end()
    }
    
//************************************************************************************************************************//
    
}
