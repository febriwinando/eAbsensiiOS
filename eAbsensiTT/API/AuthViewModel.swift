import SwiftUI
import SwiftData

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var loginError: String?
    @Published var usernameError: String?
    @Published var passwordError: String?
    @Published var isPasswordVisible = false
    
    let baseUrl = "https://absensi.tebingtinggikota.go.id/api/ios/login/"
    
    func validateInputs() -> Bool {
        usernameError = username.isEmpty ? "Username tidak boleh kosong" : nil
        passwordError = password.isEmpty ? "Password tidak boleh kosong" : nil
        
        return !username.isEmpty && !password.isEmpty
    }
    
    func login(context: ModelContext, completion: @escaping () -> Void) {
        guard validateInputs() else {
            return
        }
        
        isLoading = true
        loginError = nil
        
        guard let url = URL(string: baseUrl) else { return }
        
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            guard let data = data, error == nil else { return }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    if loginResponse.status == 201, let userData = loginResponse.user, let token = loginResponse.token {
                        let newUser = User(
                            id: userData.id,
                            employee_id: userData.employee_id,
                            username: userData.username,
                            akses: userData.akses,
                            role: userData.role,
                            active: userData.active,
                            created_at: userData.created_at,
                            updated_at: userData.updated_at,
                            token: token
                        )
                        context.insert(newUser)
                        self.isAuthenticated = true
                        completion()
                    } else if loginResponse.status == 401 {
                        self.loginError = "Username atau password salah"
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
