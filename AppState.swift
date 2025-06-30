import Foundation
import SwiftUI

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
