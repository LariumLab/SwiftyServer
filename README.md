### How to run server
    chmod 777 ServerScript
    ./ServerScript RunServer

### SwiftyServer API
### public:
    http://localhost:8080/api/getCityList -> [String]
    http://localhost:8080/api/getSalonListInCity?city -> [SalonPreview] (LogicalClasses/Salon)
    http://localhost:8080/api/getSalonInfo?salonID -> SalonInfo (LogicalClasses/Salon)
### salon:
    http://localhost:8080/api/salon/signUp?nickName&password -> String (token)
    http://localhost:8080/api/salon/signIn?nickName&password -> String (token)
    http://localhost:8080/api/salon/postSalonInfo?token -> HTTP status code (OK)
### client:


