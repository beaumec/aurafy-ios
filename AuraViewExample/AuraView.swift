import SwiftUI

struct AuraView: View {
    @State private var auraLevel: Double = 0
    @State private var showAura: Bool = true

    private var auraScale: CGFloat {
        // Scale from 1.0 (no aura) up to ~3.0 at auraLevel 100
        1 + CGFloat(auraLevel / 50)
    }

    private var auraBlur: CGFloat {
        // Blur increases with aura level
        CGFloat(auraLevel / 5)
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 40) {
                ZStack {
                    if showAura {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.2)]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 150, height: 150)
                            .scaleEffect(auraScale)
                            .blur(radius: auraBlur)
                            .opacity(auraLevel / 100)
                            .animation(.easeInOut(duration: 0.3), value: auraLevel)
                            .animation(.easeInOut(duration: 0.3), value: showAura)
                    }

                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                }

                VStack(spacing: 20) {
                    Button("Hype Me Up") {
                        withAnimation {
                            auraLevel = min(100, auraLevel + 10)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                    Toggle("Show Aura", isOn: $showAura)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}

struct AuraView_Previews: PreviewProvider {
    static var previews: some View {
        AuraView()
    }
}

