//
//  APIManager.swift
//  e-Absensi
//
//  Created by Diskominfo Tebing Tinggi on 01/10/24.
//

import Foundation

class APIManager {
    private let baseURL = "https://absensi.tebingtinggikota.go.id/api/ios/"
    
    // Method untuk mendapatkan data presensi
    func getPresensi(employeeID: Int, tanggal: String, method: String = "GET", completion: @escaping (Result<Presensi, Error>) -> Void) {
        let urlString = "\(baseURL)presences?employee_id=\(employeeID)&tanggal=\(tanggal)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method // Mengatur metode sesuai dengan parameter yang diberikan
        
        // Jika metode adalah POST, Anda bisa menambahkan body request di sini
//        if method == "POST" {
//            let parameters: [String: Any] = ["employee_id": employeeID, "tanggal": tanggal]
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            } catch {
//                completion(.failure(error))
//                return
//            }
//        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responsePresensi = try decoder.decode(ResponsePresensi.self, from: data)
                
                if responsePresensi.status == "success" {
                    completion(.success(responsePresensi.data))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Request failed with status: \(responsePresensi.status)"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
