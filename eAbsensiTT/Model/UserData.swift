//
//  UserData.swift
//  eAbsensiTT
//
//  Created by Diskominfo Tebing Tinggi on 04/02/25.
//

import Foundation

struct UserData: Codable, Identifiable {
    var id: Int
    var employee_id: Int
    var username: String
    var akses: String
    var role: String?
    var active: Int
    var created_at: String
    var updated_at: String
}
