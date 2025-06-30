import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Vortex: Identifiable, Codable {
    @DocumentID var id: String?
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var auraLevel: Int
}

struct AuraMapView: View {
    @State private var vortices: [Vortex] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: vortices) { vortex in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: vortex.latitude, longitude: vortex.longitude))
        }
        .onAppear(perform: startListening)
        .onDisappear(perform: stopListening)
    }

    private func startListening() {
        listener = db.collection("vortexes")
            .order(by: "auraLevel", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                vortices = documents.compactMap { try? $0.data(as: Vortex.self) }
            }
    }

    private func stopListening() {
        listener?.remove()
    }
}

