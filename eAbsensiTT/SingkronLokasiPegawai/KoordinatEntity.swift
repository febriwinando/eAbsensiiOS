import SwiftData
import Foundation  // Perlu untuk UUID

@Model
class KoordinatEntity {
    @Attribute(.unique) var id: UUID
    var alamat: String
    var letKoordinat: Double
    var lngKoordinat: Double
    
    init(id: UUID = UUID(), alamat: String, letKoordinat: Double, lngKoordinat: Double) {
        self.id = id
        self.alamat = alamat
        self.letKoordinat = letKoordinat
        self.lngKoordinat = lngKoordinat
    }
}
