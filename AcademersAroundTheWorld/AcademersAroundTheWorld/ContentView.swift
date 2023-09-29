//
//  ContentView.swift
//  AcademersAroundTheWorld
//
//  Created by Lucas Cavalherie on 29/09/23.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var selectedItems = [PhotosPickerItem]()
    var firebaseStorageManager = FirebaseStorageManager()
    @ObservedObject var imageSaved = ImagesSaved.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<imageSaved.images.count, id: \.self) { i in
                        imageSaved.images[i]
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                }
                
                Button {
                    Task {
                        for item in selectedItems {
                            if let data = try? await item.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    let uuidString : String = UUID().description
                                    firebaseStorageManager.upload(uuid: uuidString, data: data, atPath: "/arquivos/"+uuidString) { url, error in
                                        if let error = error {
                                            print("Erro ao fazer upload: \(error.localizedDescription)")
                                        } else if let downloadURL = url {
                                            print("Upload bem-sucedido! URL de download: \(downloadURL.absoluteString)")
                                        }
                                    }
                                    
                                    imageSaved.getImages()
                                }
                            }
                        }
                    }
                } label: {
                    Text("Subir imagens")
                }
                
                Button {
                    Task {
                        firebaseStorageManager.delete(atPath: "/arquivos/") { error in
                            if let error = error {
                                print("Erro ao fazer delete: \(error.localizedDescription)")
                            }
                        }
                    }
                } label: {
                    Text("Deletar imagens")
                }
                Button {
                    Task {
                        imageSaved.getImages()
                    }
                } label: {
                    Text("Recarregar Imagens")
                }
            }
            .toolbar{
                PhotosPicker("Select images", selection: $selectedItems, matching: .images)
            }
        }
    }
}


#Preview {
    ContentView()
}
