import SwiftUI
import SwiftData

struct DashboardView: View {
    
    @StateObject var authViewModel = AuthViewModel()
    @Environment(\.modelContext) var modelContext
    
    @State private var showKehadiranPopup = false
    @State private var showIzinPopup = false
    
    @State private var showIzinSheet = false
    @StateObject private var viewModel = PresensiViewModel()
    
    @StateObject private var koordinatViewModel = KoordinatViewModel()
    @Query var koordinatList: [KoordinatEntity]
    @Query var users: [User]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    GeometryReader { geometry in
                        VStack {
                            // Bagian layout yang sudah ada sebelumnya
                            ZStack(alignment: .top) {
                                
                                Image("tebingtinggikota")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                                    .clipShape(RoundedCorners(topLeft: 0, topRight: 0, bottomLeft: 40, bottomRight: 40))
                                    .clipped()
                                
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "bell.fill")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                    Spacer()
                                    Button(action: {}) {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, geometry.safeAreaInsets.top + 40)
                            }
                            .frame(height: geometry.size.height * 0.3)
                            
                            // Bagian yang menampilkan presensi pegawai
                            VStack {
                                HStack {
                                    Image("calendar")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text(FormatDate.getFormattedDate())
                                        .font(.headline)
                                    

                                }
                                
                                HStack {
                                    HStack {
                                        Image("ic_arrowupwhite")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        Text(viewModel.presensi?.jamMasuk ?? "--:--")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color(hex: "#008DDA"))
                                    .cornerRadius(20)
                                    
                                    HStack {
                                        Text(viewModel.presensi?.jamPulang ?? "--:--")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Image("ic_arrowdownwhite")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding()
                                    .background(Color(hex: "#008DDA"))
                                    .cornerRadius(20)
                                }
                            }
                            .frame(width: geometry.size.width*0.9, height: geometry.size.height * 0.15)
                            .background(Color.white)
                            .cornerRadius(40)
                            .shadow(radius: 2)
                            .padding(.top, -80)
                            
                            GeometryReader { geometry in
                                HStack {
                                    
                                    Text("Cari Rekap Kehadiran") // Teks di sebelah kiri
                                        .foregroundColor(Color(hex: "#008DDA"))
                                        .font(.headline)
                                        .padding(.leading, 16) // Menambahkan padding di kiri
                                    
                                    Spacer() // Spacer untuk mendorong ikon ke sisi kanan
                                    
                                    Image("ic_search") // Ganti "search_icon" dengan nama file .png Anda
                                        .resizable()
                                        .frame(width: 24, height: 24) // Ukuran ikon pencarian
                                        .padding(.trailing, 16) // Menambahkan padding di kanan
                                }
                                .frame(width: geometry.size.width, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(hex: "#008DDA"), lineWidth: 1) // Garis tepi putih dengan ketebalan 2
                                )
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .padding(10)
                            .frame(height: 70)
                            .padding(.top, geometry.safeAreaInsets.top )
                            
                            
                            // Tombol Kehadiran, Perjalanan Dinas, dan Izin
                            HStack(spacing: 10) {
                                
                                // Tombol Kehadiran dengan Popup
                                Button(action: {
                                    showKehadiranPopup = true
                                }) {
                                    VStack{
                                        Image("ic_kehadiran")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        
                                        Text("Kehadiran")
                                            .foregroundColor(.white)
                                        
                                    }
                                    
                                }
                                .frame(width: geometry.size.width * 0.26, height: geometry.size.height * 0.12)
                                .background(Color(hex: "#008DDA"))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                
                                // Tombol lainnya tidak berubah
                                NavigationLink(destination: KeteranganPerjalananDinasView()) {
                                    VStack{
                                        Image("ic_pd")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        
                                        Text("Perjalanan Dinas")
                                            .foregroundColor(.white)
                                        
                                    }

                                }
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.15)
                                .background(Color(hex: "#008DDA"))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                
                                Button(action: {
                                    showIzinPopup = true
                                }) {
                                    VStack{
                                        Image("ic_izin")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        
                                        Text("Kehadiran")
                                            .foregroundColor(.white)
                                        
                                    }
                                }
                                .frame(width: geometry.size.width * 0.26, height: geometry.size.height * 0.12)
                                .background(Color(hex: "#008DDA"))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                            .padding(.top, 20)
                            
                            
                            VStack(spacing: 10) {
                                ScrollView{
                                    Button(action: {
                                        showIzinPopup = true
                                    }) {
                                        HStack {
                                            Text("Singkronkan Jadwal")
                                                .foregroundColor(Color(hex: "#008DDA"))
                                                .font(.headline)
                                            
                                            Spacer() // Mendorong gambar ke kanan
                                            
                                            Image("ic_addcalendar")
                                                .resizable()
                                                .frame(width: 20, height: 20) // Ukuran gambar
                                                .padding(5)
                                                .background(Color(hex: "#D70654"))
                                                .clipShape(Circle()) // Membuatnya menjadi lingkaran
                                            
                                        }
                                        
                                        .padding(10)
                                        .frame(width: geometry.size.width * 0.9)
                                        .background(Color(hex: "#ffffff"))
                                        .cornerRadius(20)
                                        .shadow(radius: 2)
                                    }
                                    
                                    Button(action: {
                                        if let firstUser = users.first {
                                            Task {
                                                await koordinatViewModel.fetchKoordinat(employeeID: firstUser.employee_id, modelContext: modelContext)
                                            }
                                        }
                                    }) {
                                        HStack {
                                            Text("Singkronkan Lokasi")
                                                .foregroundColor(Color(hex: "#008DDA"))
                                                .font(.headline)
                                            
                                            Spacer() // Mendorong gambar ke kanan
                                            
                                            Image("ic_addloc")
                                                .resizable()
                                                .frame(width: 20, height: 20) // Ukuran gambar
                                                .padding(5)
                                                .background(Color(hex: "#FFD95F"))
                                                .clipShape(Circle()) // Membuatnya menjadi lingkaran
                                            
                                        }
                                        
                                        .padding(10)
                                        .frame(width: geometry.size.width * 0.9)
                                        .background(Color(hex: "#ffffff"))
                                        .cornerRadius(20)
                                        .shadow(radius: 2)
                                    }
                                    
                                    Button(
                                        action: deleteAllData
                                    ) {
                                        HStack {
                                            Text("Singkronkan Kegiatan")
                                                .foregroundColor(Color(hex: "#008DDA"))
                                                .font(.headline)
                                            
                                            Spacer() // Mendorong gambar ke kanan
                                            
                                            Image("ic_addact")
                                                .resizable()
                                                .frame(width: 20, height: 20) // Ukuran gambar
                                                .padding(5)
                                                .background(Color(hex: "#5CB338"))
                                                .clipShape(Circle()) // Membuatnya menjadi lingkaran
                                            
                                        }
                                        
                                        .padding(10)
                                        .frame(width: geometry.size.width * 0.9)
                                        .background(Color(hex: "#ffffff"))
                                        .cornerRadius(20)
                                        .shadow(radius: 2)
                                    }
                                    

                                    List(koordinatList) { koordinat in
                                                        VStack(alignment: .leading) {
                                                            Text(koordinat.alamat)
                                                                .font(.headline)
                                                            Text("Lat: \(koordinat.letKoordinat), Lng: \(koordinat.lngKoordinat)")
                                                                .font(.subheadline)
                                                                .foregroundColor(.gray)
                                                        }
                                                    }
                                }
                            }.padding(.top, 20)

                        }
                    }
                    .ignoresSafeArea()
                }
                
                // Popup Kehadiran
                if showKehadiranPopup {
                    VStack {
                        Spacer()
                        VStack() {
                            Text("KEHADIRAN")
                                .font(.headline)
                            
                            GeometryReader { geometry in
                                HStack { // Menyusun tombol dalam arah horizontal
                                    // Tombol "Cuti"
                                    NavigationLink(destination: AbsenPegawai()) {
                                        
                                        VStack{
                                            Image("ic_masukkantor")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                            
                                            Text("Masuk/Pulang\nKantor")
                                                .foregroundColor(.white)
                                        }

                                    }
                                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.85)
                                    .background(Color(hex: "#008DDA"))
                                    .cornerRadius(20)
                                    .shadow(radius: 1)
                                    
                                    
                                    NavigationLink(destination: TugasLapangan()) {
                                        
                                        VStack{
                                            Image("ic_tl")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                            
                                            Text("Tugas\nLapangan")
                                                .foregroundColor(.white)
                                        }

                                    }
                                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.85)
                                    .background(Color(hex: "#008DDA"))
                                    .cornerRadius(20)
                                    .shadow(radius: 1)
                                    
                                }
                                .frame(maxWidth: .infinity)
                            }.ignoresSafeArea()
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.15) // Mengatur ukuran GeometryReader
                            
                            Button(action: {
                                showKehadiranPopup = false
                            }) {
                                Text("Batal")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(40)
                        .shadow(radius: 20)
                        .padding(.horizontal, 30)
                        Spacer()
                    }
                    .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                }
                
                if showIzinPopup {
                    VStack {
                        Spacer()
                        VStack(spacing: 20) {
                            Text("Izin")
                                .font(.headline)
                            
                            // Navigation ke Absen Pegawai
                            NavigationLink(destination: Cuti()) {
                                Text("Cuti")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            // Navigation ke Tugas Lapangan
                            NavigationLink(destination: Sakit()) {
                                Text("Sakit")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            // Navigation ke Tugas Lapangan
                            NavigationLink(destination: KeperluanPribadi()) {
                                Text("Keperluan Pribadi")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                showIzinPopup = false
                            }) {
                                Text("Batal")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(40)
                        .shadow(radius: 20)
                        .padding(.horizontal, 30)
                        Spacer()
                    }
                    .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                }
            }
            .background(Color(hex: "#f4f4f4"))
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true) // Tambahkan ini
            
            

        }.onAppear {
            if let firstUser = users.first{
                viewModel.fetchPresensi(employeeID: firstUser.employee_id, tanggal: getFormattedDate())
            }
            
        }
    }
    
    
    func getFormattedDate() -> String {
        
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(directories[0])
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    
    func deleteAllData() {
        do {
            let users = try modelContext.fetch(FetchDescriptor<User>())
            for user in users {
                modelContext.delete(user)
            }
            try modelContext.save()
            print("Semua data berhasil dihapus")
        } catch {
            print("Gagal menghapus data: \(error)")
        }
    }
}
