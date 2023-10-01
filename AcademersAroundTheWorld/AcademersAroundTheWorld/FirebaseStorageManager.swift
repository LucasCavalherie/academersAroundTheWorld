//
//  Storage.swift
//  AcademersAroundTheWorld
//
//  Created by Lucas Cavalherie on 29/09/23.
//

import Foundation
import FirebaseStorage
import SwiftUI

class FirebaseStorageManager {
    
    private var storage: Storage
    private var storageReference: StorageReference
    
    init() {
        self.storage = Storage.storage()
        self.storageReference = storage.reference()
    }
    
    // CREATE - Upload Data
    func upload(title: String, uuid: String, data: Data, atPath path: String, completion: @escaping (URL?, Date?, Error?) -> Void) {
        let reference = storageReference.child(path)
        
        let newMetadata = StorageMetadata()
        newMetadata.customMetadata = ["uuid" : uuid, "title": title]
        
        reference.putData(data, metadata: newMetadata) { metadata, error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            
            reference.downloadURL { url, error in
                completion(url, metadata?.timeCreated, error)
            }
        }
    }
    
    func listImageNames(completion: @escaping ([String]?, Error?) -> Void) {
        let reference = storageReference.child("/arquivos/")
        
        reference.listAll{ result, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let result = result {
                let imageNames = result.items.map { $0.name }
                completion(imageNames, nil)
            }
        }
    }
    
    func downloadAll(fromPath fileNames: [String], completion: @escaping ([ImageModel]?, Error?) -> Void) {
        var datas : [ImageModel] = []
        for fileName in fileNames {
            download(fromPath: fileName){ model, error in
                if let model = model {
                    datas.append(model)
                    completion(datas, error)
                }
            }
        }
    }
    
    // READ - Download Data
    func download(fromPath fileName: String, completion: @escaping (ImageModel?, Error?) -> Void) {
        let reference = storageReference.child("/arquivos/"+fileName)
        
        var name: String  = ""
        var title: String  = ""
        var date: Date  = Date()
        
        reference.getMetadata() { data, error in
            if let data = data {
                if let customMetadata = data.customMetadata {
                    name = customMetadata["uuid"] ?? ""
                    title = customMetadata["title"] ?? ""
                }
                
                if let time = data.timeCreated {
                    date = time
                }
            }
        }
        
        reference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                if let uiImage = UIImage(data: data) {
                    let model = ImageModel(title: title, name: name, time: date, image: Image(uiImage: uiImage))
                    completion(model, nil)
                } else {
                    print("Dados de imagem inválidos")
                }
                
            }
        }
    }
    
    // DELETE
    func delete(atPath path: String, completion: @escaping (Error?) -> Void) {
        let reference = storageReference.child(path)
        reference.delete(completion: completion)
    }
    
    // A helper method to generate paths might also be useful
    func generatePath(forFilename filename: String, inDirectory directory: String) -> String {
        return "\(directory)/\(filename)"
    }
}
