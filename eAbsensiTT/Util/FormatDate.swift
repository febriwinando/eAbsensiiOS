//
//  FormatDate.swift
//  e-Absensi
//
//  Created by Diskominfo Tebing Tinggi on 01/10/24.
//

// FormatDate.swift
import Foundation

struct FormatDate {
    // Fungsi untuk mendapatkan tanggal dalam format yang diinginkan
    static func getFormattedDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID") // Mengatur bahasa ke Bahasa Indonesia
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        
        return dateFormatter.string(from: currentDate)
    }
}
