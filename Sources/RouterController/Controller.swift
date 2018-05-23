//
//  Controller.swift
//  serverPackageDescription
//
//  Created by Gleb Vasyutin on 11.04.2018.
//

import Foundation
import Kitura
import Data

public class Controller{
    
    let router : Router
    let port : Int
    
    let dataBase: PostgresDataBase

    public init(port: Int) throws{
        
        // private members initialisation
        self.router = Router()
        self.port = port
        self.dataBase = try PostgresDataBase()
        
        // remove kitura start page
        router.all(""){request, response, next in
            try response.status(.notFound).end()
        }
        
        // public API
        router.get("api/getCityList", handler: getCityList)
        
        router.get("api/getSalonListInCity", handler: getSalonListInCity)
        
        router.get("api/getSalonInfo", handler: getSalonInfo)
        
        router.get("api/getSalonServices", handler: getSalonServices)
        
        router.get("api/getServiceMasters", handler: getServiceMasters)
        
        router.get("api/getSalonMasters", handler: getSalonMasters)
        
        router.get("api/getMasterInfo", handler: getMasterInfo)
        
        router.get("api/getSalonImage", handler: getSalonImage)
        
        router.post("api/signIn", handler: postSignIn)
        
        
        // salon private API
        router.all("/", middleware: BodyParser())
        
        router.post("api/salon/signUp", handler: postSalonSignUp)
        
        router.post("api/salon/signIn", handler: postSalonSignIn)
        
        router.post("api/salon/addSalonInfo", handler: postSalonInfo)
        
        router.post("api/salon/addService", handler: postSalonAddService)
        
        router.post("api/salon/addNewMaster", handler: postSalonAddNewMaster)
        
        router.post("api/salon/addMasterToService", handler: postSalonAddMasterToService)
        
        router.post("api/salon/approveAppointment", handler: updateSalonApproveAppointment)
        
        router.get("api/salon/checkAppointments", handler: getSalonCheckAppointments)
        
        router.get("api/salon/getSalonID", handler: getSalonIDFromToken)
        
        // client private API
        router.post("api/client/signUp", handler: postClientSignUp)
        
        router.post("api/client/signIn", handler: postClientSignIn)
        
        router.post("api/client/makeAppointment", handler: postClientMakeAppointment)
        
        router.get("api/client/checkAppointments", handler: getClientCheckAppointments)
        
        router.get("api/client/getProfile", handler: getClientProfile)
        
        // files
        router.all("/files/images", middleware: StaticFileServer(path: "./Files"))
        
    }
    
    // Get private members of the class
    public func getRouter() -> Router {
        return self.router
    }
    
    public func getPort() -> Int {
        return self.port
    }

}
