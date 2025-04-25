import Foundation
import SwiftData

struct Koordinat: Codable, Identifiable {
    let id: Int
    let employee_id: Int
    let alamat: String
    let letKoordinat: String
    let lngKoordinat: String
    
    

    enum CodingKeys: String, CodingKey {
        case id, employee_id, alamat
        case letKoordinat = "let"
        case lngKoordinat = "lng"
    }
}
