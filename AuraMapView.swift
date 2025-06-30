import SwiftUI
import MapKit

struct Vortex: Identifiable {
    let id = UUID()
    let username: String
    let coordinate: CLLocationCoordinate2D
    let auraLevel: Double
}

struct AuraMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    // Mock data
    let vortexes: [Vortex] = [
        Vortex(username: "Alice", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), auraLevel: 80),
        Vortex(username: "Bob", coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), auraLevel: 60),
        Vortex(username: "Carol", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), auraLevel: 90)
    ]

    @State private var selectedVortex: Vortex?

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: vortexes) { vortex in
            MapAnnotation(coordinate: vortex.coordinate) {
                Button(action: {
                    selectedVortex = vortex
                }) {
                    Circle()
                        .fill(Color.purple.opacity(0.4 + 0.6 * (vortex.auraLevel / 100)))
                        .frame(width: 20 + CGFloat(vortex.auraLevel / 5), height: 20 + CGFloat(vortex.auraLevel / 5))
                        .overlay(
                            Circle()
                                .stroke(Color.purple, lineWidth: 2)
                                .shadow(color: Color.purple.opacity(0.8), radius: CGFloat(vortex.auraLevel / 10))
                        )
                }
            }
        }
        .sheet(item: $selectedVortex) { vortex in
            VStack(spacing: 16) {
                Text(vortex.username)
                    .font(.title)
                Text("Aura Level: \(Int(vortex.auraLevel))")
                    .font(.headline)
            }
            .padding()
        }
    }
}

struct AuraMapView_Previews: PreviewProvider {
    static var previews: some View {
        AuraMapView()
    }
}
