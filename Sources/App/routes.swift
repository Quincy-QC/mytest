import Vapor
import JWT

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }

    // Basic "Hello, world!" example
    router.get("hello") { req -> String in
        guard let bearer = req.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        let jwt = try JWT<User>(from: bearer.token, verifiedUsing: .hs256(key: "secret"))
        return "Hello, \(jwt.payload.name)!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.post("todos", "save", use: todoController.update)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    router.post("login", use: todoController.test)
}
