import SwiftUI
import Firebase
import FirebaseFirestore
import CoreLocation
import MapKit

// Data model representing a vortex
struct Vortex: Identifiable {
    var id: String
    var title: String
    var auraLevel: Double
    var coordinate: CLLocationCoordinate2D
    var ownerId: String
    var ownerName: String
}

// Simple location manager to fetch the user's current location
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocationCoordinate2D?
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}

/// View that allows the user to create a new vortex and then shows it on the map.
struct CreateVortexView: View {
    @State private var title = ""
    @State private var auraLevel: Double = 0.5
    @StateObject private var locationManager = LocationManager()
    @State private var isSaving = false
    @State private var navigate = false
    @State private var createdVortex: Vortex?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vortex Title")) {
                    TextField("Title", text: $title)
                }
                Section(header: Text("Aura Level")) {
                    Slider(value: $auraLevel, in: 0...1)
                }
                Section(header: Text("Location")) {
                    if let coord = locationManager.location {
                        Text("Lat: \(coord.latitude), Lon: \(coord.longitude)")
                    } else {
                        Text("Fetching location...")
                    }
                }
                Button(action: createVortex) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Create Vortex")
                    }
                }
                .disabled(isSaving || locationManager.location == nil || title.isEmpty)
                NavigationLink(
                    destination: AuraMapView(vortex: createdVortex),
                    isActive: $navigate,
                    label: { EmptyView() }
                )
            }
            .navigationTitle("New Vortex")
        }
    }

    private func createVortex() {
        guard let user = Auth.auth().currentUser,
              let coord = locationManager.location else { return }
        isSaving = true

        var data: [String: Any] = [
            "title": title,
            "auraLevel": auraLevel,
            "uid": user.uid,
            "userName": user.displayName ?? "",
            "location": GeoPoint(latitude: coord.latitude, longitude: coord.longitude),
            "createdAt": Timestamp(date: Date())
        ]

        let docRef = Firestore.firestore().collection("vortexes").document()
        docRef.setData(data) { error in
            isSaving = false
            if error == nil {
                createdVortex = Vortex(id: docRef.documentID,
                                       title: title,
                                       auraLevel: auraLevel,
                                       coordinate: coord,
                                       ownerId: user.uid,
                                       ownerName: user.displayName ?? "")
                navigate = true
            }
        }
    }
}

/// Simple map view used after creating a vortex.
struct AuraMapView: View {
    var vortex: Vortex?
    @State private var region: MKCoordinateRegion

    init(vortex: Vortex?) {
        let center = vortex?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        _region = State(initialValue: MKCoordinateRegion(center: center,
                                                         span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: vortex != nil ? [vortex!] : []) { vortex in
            MapMarker(coordinate: vortex.coordinate, tint: .purple)
        }
        .navigationTitle(vortex?.title ?? "Aura Map")
    }
}

