//
//  FirestoreManager.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 16/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import Firebase

class FirestoreManager {
    
    // MARK: - Properties
    
    static let shared = FirestoreManager()
    private let dataBase = Firestore.firestore()
    private init() {}
    
    private var usersReference: CollectionReference {
        return dataBase.collection("users")
    }
    
    // MARK: - Methods
    
    func saveProfile(user: UserModel, userImage: UIImage?, completion: @escaping (Result<UserModel, Error>) -> Void) {
        self.usersReference.document(user.id).setData(user.representation) { (error) in
            guard let error = error else {
                completion(.success(user))
                return
            }
            completion(.failure(error))
        }
    }
}
