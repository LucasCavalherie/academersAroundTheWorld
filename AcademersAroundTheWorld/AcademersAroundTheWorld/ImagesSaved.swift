//
//  ImagesSaved.swift
//  AcademersAroundTheWorld
//
//  Created by Lucas Cavalherie on 29/09/23.
//

import Foundation
import SwiftUI

class ImagesSaved : ObservableObject {
    @Published var images : [Image] = []
    var firebaseStorageManager = FirebaseStorageManager()
    
    static let shared = ImagesSaved()
    private init() {
        //getImages()
    }
    
    func getImages(){
        print("Começou")
        firebaseStorageManager.download(fromPath: "/arquivos/") { data, error in
            if let error = error {
                print("Erro ao fazer download: \(error.localizedDescription)")
            } else if let data = data {
                print("Download bem-sucedido!: \(data)")
                
                for item in data {
                    if let uiImage = UIImage(data: item.data) {
                        print("Dados de imagem válidos")
                        self.images.append(Image(uiImage: uiImage))
                    } else {
                        print("Dados de imagem inválidos")
                    }
                }
            }
        }
    }
    
}
