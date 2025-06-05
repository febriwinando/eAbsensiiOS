import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    @Environment(\.modelContext) var modelContext
    @State private var isNavigating = false
    
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        
        NavigationView {
            VStack(spacing: 10) {
                
                Image("absensilogo") // Pastikan gambar ada di Assets
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                
                Text("e-Absensi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#006da4"))
                
                // Menampilkan pesan error jika ada
                if let loginError = authViewModel.loginError {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if let usernameError = authViewModel.usernameError, let passwordError = authViewModel.passwordError {
                    Text("NIP / NIK atau password tidak boleh kosong")
                        .foregroundColor(.red)
                        .padding()
                } else if let usernameError = authViewModel.usernameError {
                    Text(usernameError)
                        .foregroundColor(.red)
                        .padding()
                } else if let passwordError = authViewModel.passwordError {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Input Username
                TextField("NIP / NIK", text: $authViewModel.username)
                    .padding()
                    .frame(height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Input Password
                ZStack(alignment: .trailing) {
                    if authViewModel.isPasswordVisible {
                        TextField("Password", text: $authViewModel.password)
                            .padding()
                            .frame(height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    } else {
                        SecureField("Password", text: $authViewModel.password)
                            .padding()
                            .frame(height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        authViewModel.isPasswordVisible.toggle()
                    }) {
                        Image(systemName: authViewModel.isPasswordVisible ? "eye.slash" : "eye")
                            .padding()
                    }
                    .padding(.trailing, 16)
                }
                
                // Tombol Login
                Button(action: {
                    authViewModel.login(context: modelContext) {
                        isNavigating = true
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if authViewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                // Tombol Hapus Semua Data
                Button(action: deleteAllData) {
                    Text("Hapus Semua Data")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    checkUserData()
                }
            }
            .fullScreenCover(isPresented: $isNavigating, content: {
                DashboardView()
            })
        }
    }
    
    // Fungsi untuk mengecek apakah ada data pengguna di SwiftData
    func checkUserData() {
        do {
            let users: [User] = try modelContext.fetch(FetchDescriptor<User>())
            if !users.isEmpty {
                DispatchQueue.main.async {
                    isNavigating = true
                }
                print("Ada data pengguna")
            } else {
                print("Tidak ada data pengguna")
            }
        } catch {
            print("Gagal mengambil data pengguna: \(error)")
        }
    }
    
    // Fungsi untuk menghapus semua data pengguna dari SwiftData
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
