//
//  KoordinatViewModel.swift
//  eAbsensiTT
//
//  Created by Diskominfo Tebing Tinggi on 07/02/25.
//

import SwiftData
import SwiftUI

class KoordinatViewModel: ObservableObject {
    @Published var koordinatList: [KoordinatEntity] = []
    
    let baseURL = "https://absensi.tebingtinggikota.go.id/api/ios/koordinat?employee_id="
    
    func fetchKoordinat(employeeID: Int, modelContext: ModelContext) async {
        guard let url = URL(string: "\(baseURL)\(employeeID)") else {
            print("URL tidak valid")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([Koordinat].self, from: data)
            
            if decodedResponse.isEmpty {
                print("Data kosong atau employee_id salah")
                return
            }
            
            DispatchQueue.main.async {
                self.saveToSwiftData(decodedResponse, modelContext: modelContext)
            }
        } catch {
            print("Gagal mengambil data: \(error)")
        }
    }
    
    private func saveToSwiftData(_ koordinats: [Koordinat], modelContext: ModelContext) {
        do {
            for koordinat in koordinats {
                guard let letKoordinat = Double(koordinat.letKoordinat),
                      let lngKoordinat = Double(koordinat.lngKoordinat) else {
                    print("Gagal mengonversi koordinat ke Double")
                    continue
                }

                let entity = KoordinatEntity(
                    id: UUID(),
                    alamat: koordinat.alamat,
                    letKoordinat: letKoordinat,
                    lngKoordinat: lngKoordinat
                )
                modelContext.insert(entity)
            }
            try modelContext.save()
            print("Data berhasil disimpan ke SwiftData")
        } catch {
            print("Gagal menyimpan ke SwiftData: \(error)")
        }
    }

}
