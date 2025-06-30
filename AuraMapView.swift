import SwiftUI
import MapKit

struct Vortex: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let influencerName: String
    var auraLevel: Int
}

struct AuraMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var vortices: [Vortex] = [
        Vortex(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), influencerName: "Influencer A", auraLevel: 5)
    ]
    @State private var selectedVortex: Vortex?

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: vortices) { vortex in
            MapAnnotation(coordinate: vortex.coordinate) {
                Button(action: {
                    selectedVortex = vortex
                }) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
        }
        .sheet(item: $selectedVortex) { vortex in
            VStack(spacing: 20) {
                Text(vortex.influencerName)
                    .font(.title)
                Text("Aura Level: \(vortex.auraLevel)")
                    .font(.headline)
                Button("\u2728 Hype Me Up") {
                    // TODO: add hype action
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
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
