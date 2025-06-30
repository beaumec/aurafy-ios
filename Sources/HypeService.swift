import FirebaseFirestore

/// Provides functionality for hyping up a vortex.
struct HypeService {
    /// Hypes up a vortex and optionally notes which user performed the hype.
    /// - Parameters:
    ///   - vortexID: Identifier of the vortex to hype.
    ///   - userID: Identifier of the user sending the hype. Pass `nil` if anonymous.
    ///   - completion: Called when the operation finishes. Contains an error if one occurred.
    static func hype(vortexID: String, from userID: String?, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let vortexRef = db.collection("vortexes").document(vortexID)

        db.runTransaction({ transaction, errorPointer -> Any? in
            do {
                // Fetch current vortex data
                let vortexSnapshot = try transaction.getDocument(vortexRef)
                let currentLevel = vortexSnapshot.data()? ["auraLevel"] as? Int ?? 0
                // Increase aura level by 5 but do not exceed 100
                let newLevel = min(currentLevel + 5, 100)
                transaction.updateData(["auraLevel": newLevel], forDocument: vortexRef)

                // Append the user to the hypers array if provided
                if let userID = userID {
                    transaction.updateData([
                        "hypers": FieldValue.arrayUnion([userID])
                    ], forDocument: vortexRef)

                    let userRef = db.collection("users").document(userID)
                    if let userSnapshot = try? transaction.getDocument(userRef) {
                        let currentAura = userSnapshot.data()? ["aura"] as? Int ?? 0
                        transaction.updateData(["aura": currentAura + 2], forDocument: userRef)
                    } else {
                        transaction.setData(["aura": 2], forDocument: userRef, merge: true)
                    }
                }
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            return nil
        }, completion: { _, error in
            completion(error)
        })
    }
}
