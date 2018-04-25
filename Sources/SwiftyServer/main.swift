import Kitura
import RouterController

let controller = try Controller(port: 8080)
Kitura.addHTTPServer(onPort: controller.getPort(), with: controller.getRouter())

Kitura.run()
