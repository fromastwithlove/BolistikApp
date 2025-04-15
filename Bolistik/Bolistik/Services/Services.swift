//
//  Services.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 13.03.25.
//

actor Services {
    let firestoreService: FirestoreService = FirestoreService()
    let firebaseStorageService: FirebaseStorageService = FirebaseStorageService()
    let networkService: NetworkService = NetworkService()
}
