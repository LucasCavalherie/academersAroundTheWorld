//
//  ImagesSaved.swift
//  AcademersAroundTheWorld
//
//  Created by Lucas Cavalherie on 29/09/23.
//

import Foundation
import SwiftUI

class ImagesViewModel : ObservableObject {
    @Published var images : [ImageModel] = []
    
    var firebaseStorageManager = FirebaseStorageManager()
    
    let userDefaultsKey = "imageName"
    
    static let shared = ImagesViewModel()
    private init() {
        //getImages()
    }
    
    func saveNewImage(title: String, name: String, time: Date, image: Image) {
        let newImage = ImageModel(title: title, name: name, time: time, image: image)
        images.append(newImage)
    }
    
    func getImages() -> [String] {
        var imageNames: [String] = []
        firebaseStorageManager.listImageNames() { data, error in
            if let error = error {
                print("Erro ao fazer download: \(error.localizedDescription)")
            } else if let data = data {
                print("Imagens: \(data)")
                imageNames = data
                
                for image in self.images {
                    imageNames.removeAll{$0 == image.name}
                }
                
                if imageNames.count > 0 {
                    self.downloadImages(missingImageName: imageNames)
                }
            }
        }
        
        return imageNames
    }
    
    func downloadImages(missingImageName: [String])
    {
        firebaseStorageManager.downloadAll(fromPath: missingImageName) { data, error in
            if let error = error {
                print("Erro ao fazer download: \(error.localizedDescription)")
            } else if let data = data {
                print("Download bem-sucedido!: \(data)")
                
                for item in data {
                    self.images.append(item)
                }
            }
        }
    }
    
}
