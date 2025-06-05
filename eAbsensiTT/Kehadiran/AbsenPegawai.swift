import SwiftUI
import GoogleMaps
import CoreLocation

struct AbsenPegawai: View {
    
    @State private var isCameraPresented = false
    @State private var capturedImage: UIImage?
    
    @StateObject private var locationManager = LocationManager() // Menggunakan StateObject untuk locationManager

    var body: some View {
        VStack {
            // Menampilkan Google Maps View
            GoogleMapView(locationManager: locationManager)
                .clipShape(BottomRoundedCorners(radius: 50))
                .edgesIgnoringSafeArea(.top)
            
                Text("Jarak ke tujuan: \(locationManager.distanceToDestination, specifier: "%.2f") meter")
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            
            
            displayCapturedImage()
            
            Button(action: {
                withAnimation {
//                    isCameraPresented.toggle()
                }
            }) {
                Text("Absen")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding([.leading, .trailing], 10)
            }

            
        }
        .onAppear {
            locationManager.startUpdatingLocation() // Memulai pembaruan lokasi saat tampilan muncul
        }
        .onDisappear {
            locationManager.stopUpdatingLocation() // Menghentikan pembaruan lokasi saat tampilan menghilang
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
            Button(action: {
                withAnimation {
                    isCameraPresented.toggle()
                }
            }) {
                Image("camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
            }
            .fullScreenCover(isPresented: $isCameraPresented) {
                CameraView(capturedImage: $capturedImage) {
                    // This closure will be called when the image is captured
                    isCameraPresented = false
              }
                .edgesIgnoringSafeArea(.all)
            }
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
