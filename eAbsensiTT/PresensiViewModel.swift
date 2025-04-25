//
//  PresensiViewModel.swift
//  e-Absensi
//
//  Created by Diskominfo Tebing Tinggi on 01/10/24.
//

import Foundation

class PresensiViewModel: ObservableObject {
    @Published var presensi: Presensi?
    @Published var errorMessage: String?
    
    private let apiManager = APIManager()
    
    // Method untuk mengambil data presensi
    func fetchPresensi(employeeID: Int, tanggal: String, method: String = "GET") {
        apiManager.getPresensi(employeeID: employeeID, tanggal: tanggal, method: method) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let presensi):
                    self?.presensi = presensi
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
