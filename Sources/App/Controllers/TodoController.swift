import Vapor
import JWT

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.create(on: req)
        }
    }
    
    func update(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            if todo.title == "second" {
                throw Abort(.badRequest, reason: "this is error")
            }
            return todo.update(on: req, originalID: todo.id!)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
    
    func test(_ req: Request) throws -> Future<String> {
        return try req.content.decode(User.self).flatMap { user in
            let data = try JWT(payload: user).sign(using: .hs256(key: "secret"))
            let futureString = req.eventLoop.future(String(data: data, encoding: .utf8)!)
            return futureString
        }
    }
}
