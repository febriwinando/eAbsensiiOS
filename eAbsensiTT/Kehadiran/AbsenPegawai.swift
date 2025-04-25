import SwiftUI
import GoogleMaps
import CoreLocation

struct AbsenPegawai: View {
    
    @State private var isCameraPresented = false
    @State private var capturedImage: UIImage?
    
    @StateObject private var locationManager = LocationManager() // Menggunakan StateObject untuk locationManager

    var body: some View {
        VStack(spacing: 16) { // gunakan spacing agar lebih rapi
            // Google Map
            GoogleMapView(locationManager: locationManager)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                .clipShape(BottomRoundedCorners(radius: 40))
                .edgesIgnoringSafeArea(.top)

            // Jarak
            Text("Jarak ke tujuan: \(locationManager.distanceToDestination, specifier: "%.2f") meter")
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding(.horizontal)

            // Gambar yang ditangkap
            displayCapturedImage()

            // Tombol Kamera
            Button(action: {
                withAnimation {
                    isCameraPresented.toggle()
                }
            }) {
                Text("Buka Kamera")
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }

            Spacer(minLength: 20) // Spacer kecil jika ingin ada sedikit jarak bawah
        }
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
    }

    
    
    @ViewBuilder
    private func displayCapturedImage() -> some View {
        if let capturedImage = capturedImage {
            NavigationLink(destination: ImageDisplayView(selectedImage: capturedImage)) {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding()
                    .shadow(radius: 5)
            }
        } else {
            VStack {
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text("Ambil Foto")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}


struct GoogleMapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.destinationCoordinate.latitude,
                                              longitude: locationManager.destinationCoordinate.longitude, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Tidak ada marker untuk tujuan
        
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Update posisi pengguna pada peta
        if let userLocation = locationManager.currentLocation {
            // Pindahkan kamera ke lokasi pengguna
            mapView.camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude,
                                                      longitude: userLocation.longitude, zoom: 18.0)
            
            // Perbarui atau buat marker untuk lokasi pengguna
            if let userMarker = context.coordinator.userMarker {
                // Jika userMarker sudah ada, cukup perbarui posisinya
                userMarker.position = userLocation
            } else {
                // Jika userMarker belum ada, buat marker baru
                let newMarker = GMSMarker(position: userLocation)
                newMarker.title = "Lokasi Anda"
                
                // Ganti marker dengan gambar PNG kustom
                if let markerImage = UIImage(named: "ic_asnlk") {
                    newMarker.icon = markerImage // Ganti dengan ikon PNG
                }

                newMarker.map = mapView
                context.coordinator.userMarker = newMarker
            }
        }
    }

    // Coordinator untuk menyimpan referensi userMarker
    class Coordinator {
        var userMarker: GMSMarker?
    }
}
