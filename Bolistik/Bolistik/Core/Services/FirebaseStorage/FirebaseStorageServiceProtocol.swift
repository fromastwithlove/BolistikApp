//
//  FirebaseStorageServiceProtocol.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 20.07.25.
//

import UIKit

protocol FirebaseStorageServiceProtocol: Sendable {
    func fetchImage(path: String) async throws -> UIImage?
    func uploadImage(data: Data, path: String) async throws
    func deleteImage(path: String) async throws
}
