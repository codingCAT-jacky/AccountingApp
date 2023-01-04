import Foundation

class loginAccount : ObservableObject {
    @Published var user_token : String = ""
}


struct SessionUser : Encodable {
    public let user : SessionBody
}

struct SessionBody : Encodable{
    public let login : String
    public let password : String
}

struct SessionResponse : Decodable {
    public let user_token : String
    public let login : String
    public let email : String
    enum CodingKeys : String,CodingKey{
        case user_token = "User-Token"
        case login
        case email
    }
}

struct  NewUser : Encodable {
    public let user : NewUserBody
}

struct NewUserBody : Encodable {
    let login : String
    let email : String
    let password : String
}

struct  NewUserResponse : Decodable {
    let user_token : String
    let login : String
    enum CodingKeys : String,CodingKey{
        case user_token = "User-Token"
        case login
    }
}
