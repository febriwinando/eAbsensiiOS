//
//  APIService.swift
//  GetDataMVVMParams
//
//  Created by Diskominfo Tebing Tinggi on 06/02/25.
//

import Foundation

struct APIService {
    static let baseURL = "https://absensi.tebingtinggikota.go.id/api/ios/"
    
    static func fetchKoordinat(employeeIDs: [Int]) async throws -> [KoordinatResponse] {
        let employeeIDString = employeeIDs.map { String($0) }.joined(separator: ",")
        let urlString = "\(baseURL)koordinat?employee_id=\(employeeIDString)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode([KoordinatResponse].self, from: data)
        
        // Jika API mengembalikan status "kosong"
        if let firstItem = decodedResponse.first, firstItem.status == "kosong" {
            return []
        }
        
        return decodedResponse
    }
}
