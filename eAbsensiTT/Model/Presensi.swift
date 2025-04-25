//
//  Presensi.swift
//  e-Absensi
//
//  Created by Diskominfo Tebing Tinggi on 01/10/24.
//

import Foundation

// Model untuk data presensi
struct Presensi: Codable {
    let jamMasuk: String?
    let jamPulang: String?

    enum CodingKeys: String, CodingKey {
        case jamMasuk = "jam_masuk"
        case jamPulang = "jam_pulang"
    }
}

// Model untuk response dari API
struct ResponsePresensi: Codable {
    let status: String
    let data: Presensi
}
