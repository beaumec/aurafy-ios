import SwiftUI
import MapKit

struct Vortex: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let username: String
    let auraLevel: Int
}

struct AuraMapView: View {
    @State private var selectedVortex: Vortex?
    // Mock data representing influencer vortex locations
    private let vortexes: [Vortex] = [
        Vortex(coordinate: CLLocationCoordinate2D(latitude: 37.7793, longitude: -122.419), username: "@aurastar", auraLevel: 90),
        Vortex(coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), username: "@influencer", auraLevel: 50),
        Vortex(coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), username: "@socialite", auraLevel: 70),
    ]

    var body: some View {
        Map {
            ForEach(vortexes) { vortex in
                MapAnnotation(coordinate: vortex.coordinate) {
                    VortexView(auraLevel: vortex.auraLevel)
                        .onTapGesture {
                            selectedVortex = vortex
                        }
                }
            }
        }
        .sheet(item: $selectedVortex) { vortex in
            VortexDetailView(vortex: vortex)
        }
    }
}

struct VortexView: View {
    let auraLevel: Int

    var body: some View {
        Circle()
            .fill(Color.purple.opacity(0.6))
            .frame(width: size, height: size)
            .shadow(color: Color.purple.opacity(shadowOpacity), radius: glowRadius)
    }

    private var size: CGFloat {
        // Base size plus scaling based on auraLevel
        20 + CGFloat(auraLevel) * 0.3
    }

    private var glowRadius: CGFloat {
        2 + CGFloat(auraLevel) * 0.2
    }

    private var shadowOpacity: Double {
        0.3 + Double(auraLevel) / 100.0 * 0.7
    }
}

struct VortexDetailView: View {
    let vortex: Vortex

    var body: some View {
        VStack(spacing: 20) {
            Text(vortex.username)
                .font(.title)
            Text("Aura Level: \(vortex.auraLevel)")
                .font(.headline)
        }
        .padding()
    }
}

#Preview {
    AuraMapView()
}
