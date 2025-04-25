//
//  KoordinatResponse.swift
//  GetDataMVVMParams
//
//  Created by Diskominfo Tebing Tinggi on 06/02/25.
//

import Foundation

struct KoordinatResponse: Codable {
    var id: Int
    var employee_id: Int
    var alamat: String
    var latitude: String
    var longitude: String
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case employee_id
        case alamat
        case latitude = "let"   // Ubah "let" menjadi "latitude"
        case longitude = "lng"  // Ubah "lng" menjadi "longitude"
        case status
    }
}
