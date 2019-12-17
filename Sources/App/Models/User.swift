import JWT

struct User: JWTPayload {
    var id: Int
    var name: String
    
    func verify(using signer: JWTSigner) throws {
        
    }
}
