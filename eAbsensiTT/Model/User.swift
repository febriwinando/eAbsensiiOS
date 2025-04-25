import SwiftData

@Model
class User: Identifiable {
    @Attribute(.unique) var id: Int
    var employee_id: Int
    var username: String
    var akses: String
    var role: String?
    var active: Int
    var created_at: String
    var updated_at: String
    var token: String
    
    init(id: Int, employee_id: Int, username: String, akses: String, role: String?, active: Int, created_at: String, updated_at: String, token: String) {
        self.id = id
        self.employee_id = employee_id
        self.username = username
        self.akses = akses
        self.role = role
        self.active = active
        self.created_at = created_at
        self.updated_at = updated_at
        self.token = token
    }
}
