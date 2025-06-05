import SwiftUI
import SwiftData
import GoogleMaps

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isLoggedIn: Bool? = nil  // State untuk status login

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            KoordinatEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if let isLoggedIn = isLoggedIn {
                if isLoggedIn {
                    DashboardView()
                        .modelContainer(sharedModelContainer)
                } else {
                    ContentView()
                        .modelContainer(sharedModelContainer)
                }
            } else {
                ProgressView() // Menampilkan indikator loading sementara
                    .onAppear {
                        Task {
                            await checkUserData()
                        }
                    }
            }
        }
    }

    // Fungsi untuk mengecek apakah tabel User memiliki data
    private func checkUserData() async {
        do {
            let users: [User] = try sharedModelContainer.mainContext.fetch(FetchDescriptor<User>())
            DispatchQueue.main.async {
                self.isLoggedIn = !users.isEmpty
            }
        } catch {
            print("Gagal mengambil data pengguna: \(error)")
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        }
    }
}

// Inisialisasi AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyD9472DJ2F3NDSgB9VMJUj8zEETXdvJy9CnlkRF1-8")
        return true
    }
}
