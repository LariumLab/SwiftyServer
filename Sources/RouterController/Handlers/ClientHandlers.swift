import Foundation
import Kitura
import PerfectPostgreSQL
import PerfectCRUD
import Classes
import CryptoSwift

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
        let query = clientTable.where(\Client.phoneNumber == phoneNumber)
        if (try query.count() != 0){
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
        let clientTable = self.dataBase.clientTable
        let query = clientTable.where(\Client.phoneNumber == phoneNumber)
        if (try query.count() != 1){
            try response.status(.badRequest).end()
            return
        }
        let salt = "SwiftyServer"
        let tokenString = phoneNumber + salt + password
        let token = tokenString.md5()
        let values = try query.select()
        for client in values{
            if (client.token == token){
                try response.status(.OK).send(token).end()
            }else{
                try response.status(.badRequest).end()
            }
        }
    }
    
//************************************************************************************************************************//
    
}
