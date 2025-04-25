import Foundation

struct LoginResponse: Codable {
    let user: UserData?
    let nama: String?
    let token: String?
    let status: Int
}
