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
        
        // public api
        router.get("api/getCityList", handler: getCityList)
        
        router.get("api/getSalonListInCity", handler: getSalonListInCity)
        
        router.get("api/getSalonInfo", handler: getSalonInfo)
        
        router.get("api/getSalonServices", handler: getSalonServices)//
        
        router.get("api/getServiceMasters", handler: getServiceMasters)//
        
        router.get("api/getMasterInfo", handler: getMasterInfo)//
        
        router.get("api/getMasterSchedule", handler: getMasterSchedule)//
        
        // salon private api
        router.post("api/salon/registration", handler: postSalonRegistration)
        
        
    }
    //
    // Get private members of the class
    public func getRouter() -> Router {
        return self.router
    }
    
    public func getPort() -> Int {
        return self.port
    }

}
