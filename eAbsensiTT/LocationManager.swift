import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var distanceToDestination: CLLocationDistance = 0.0

    // Lokasi tujuan
    let destinationCoordinate = CLLocationCoordinate2D(latitude: 3.3348937, longitude: 99.1711731)

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.updateDistanceToDestination()
        }
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    private func updateDistanceToDestination() {
        guard let currentLocation = locationManager.location else { return }
        let destinationLocation = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        distanceToDestination = currentLocation.distance(from: destinationLocation)
    }

    // CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            print("Akses lokasi tidak diizinkan.")
        }
    }
}
