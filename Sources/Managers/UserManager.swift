import Foundation
import FirebaseFirestore

class UserManager {
    private let db = Firestore.firestore()
    private let collection = "users"

    func saveAuraLevel(for uid: String, auraLevel: Int, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = ["uid": uid, "auraLevel": auraLevel]
        db.collection(collection).document(uid).setData(data) { error in
            completion(error)
        }
    }

    func fetchAuraLevel(for uid: String, completion: @escaping (Result<Int, Error>) -> Void) {
        db.collection(collection).document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let auraLevel = snapshot?.data()? ["auraLevel"] as? Int ?? 0
            completion(.success(auraLevel))
        }
    }
}
