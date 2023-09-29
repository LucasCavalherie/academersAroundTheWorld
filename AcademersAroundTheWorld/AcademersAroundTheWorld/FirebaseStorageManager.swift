//
//  Storage.swift
//  AcademersAroundTheWorld
//
//  Created by Lucas Cavalherie on 29/09/23.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    
    private var storage: Storage
    private var storageReference: StorageReference
    
    init() {
        self.storage = Storage.storage()
        self.storageReference = storage.reference()
    }
    
    // CREATE - Upload Data
    func upload(uuid: String, data: Data, atPath path: String, completion: @escaping (URL?, Error?) -> Void) {
        let reference = storageReference.child(path)
        
        let newMetadata = StorageMetadata()
        newMetadata.customMetadata = ["uuid" : uuid]
        
        reference.putData(data, metadata: newMetadata) { metadata, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            reference.downloadURL { url, error in
                completion(url, error)
            }
        }
    }
    
    // READ - Download Data
    func download(fromPath path: String, completion: @escaping ([ImageModel]?, Error?) -> Void) {
        let reference = storageReference.child(path)
        
        var datas : [ImageModel] = []
        
        reference.listAll{ (result, error) in
            if let error = error {
                completion(nil, error)
            }
            
            for item in result?.items ?? [] {
                
                var name: String  = ""
                var date: Date  = Date()
                
                item.getMetadata() { data, error in
                    if let data = data {
                        if let customMetadata = data.customMetadata {
                            name = customMetadata["uuid"] ?? ""
                            print(name)
                        }
                        
                        if let time = data.timeCreated {
                            date = time
                            print(date)
                        }  
                    }
                }
                
                item.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if let error = error {
                        completion(nil, error)
                    }
                    
                    if let data = data {
                        var model = ImageModel(name: name, time: date, data: data)
                        datas.append(model)
                        completion(datas, nil)
                    }
                }
            }
            
            completion(datas, nil)
        }
        completion(datas, nil)
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
