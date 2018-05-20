import Foundation
import PerfectPostgreSQL
import PerfectCRUD
import Classes

public class PostgresDataBase{
    let dataBase: Database<PostgresDatabaseConfiguration>
    
    public let clientTable: Table<Client, Database<PostgresDatabaseConfiguration>>
    public let salonTable: Table<Salon, Database<PostgresDatabaseConfiguration>>
    public let serviceTable: Table<Service, Database<PostgresDatabaseConfiguration>>
    public let masterTable: Table<Master, Database<PostgresDatabaseConfiguration>>
    public let appointmentTable: Table<Appointment, Database<PostgresDatabaseConfiguration>>
    
    public let serviceToMasterTable: Table<ServiceToMaster, Database<PostgresDatabaseConfiguration>>
    public let dayTable: Table<Day, Database<PostgresDatabaseConfiguration>>
    
    public init() throws{
        
        dataBase = Database(configuration: try PostgresDatabaseConfiguration(database: "LariumDB", host: "localhost"))
        
        try dataBase.create(Client.self)
        try dataBase.create(Salon.self)
        try dataBase.create(Day.self)
        try dataBase.create(ServiceToMaster.self)
        
        salonTable = dataBase.table(Salon.self)
        clientTable = dataBase.table(Client.self)
        serviceTable = dataBase.table(Service.self)
        masterTable = dataBase.table(Master.self)
        appointmentTable = dataBase.table(Appointment.self)
        
        serviceToMasterTable = dataBase.table(ServiceToMaster.self)
        dayTable = dataBase.table(Day.self)
        
        try serviceTable.index(\.salonID)
        try masterTable.index(\.salonID)
        try appointmentTable.index(\.salonID)
        try serviceToMasterTable.index(\.salonID)
    }
}
