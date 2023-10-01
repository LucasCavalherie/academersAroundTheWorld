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
    @ObservedObject var imagesViewModel = ImagesViewModel.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                
                Image("Top")
                
                HStack {
                    Spacer()
                    
                    Button {
                        Task {
                            imagesViewModel.getImages()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("Blue"))
                            .cornerRadius(10)
                    }
                    
                    PhotosPicker(selection: $selectedItems, matching: .images) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Enviar fotos")
                        }
                        .font(.caption)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("Blue"))
                        .cornerRadius(10)
                    }
                        
                }
                .padding()
                
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Representante da choquei")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Diretamente da Alemanha 🇩🇪")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                LazyVStack {
                    ForEach(0..<imagesViewModel.images.count, id: \.self) { i in
                        let imagem = imagesViewModel.images[i]
                        
                        ImageCard(imagem: imagem) {
                            Task {
                                firebaseStorageManager.delete(atPath: "/arquivos/\(imagem.name)") { error in
                                    if let error = error {
                                        print("Erro ao fazer delete: \(error.localizedDescription)")
                                    }
                                }
                            }
                            
                            imagesViewModel.images.removeAll(where: { $0.name == imagem.name })
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.bottom, 16)
            }
            .onChange(of: selectedItems) {
                Task {
                    for item in selectedItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                let uuidString : String = UUID().description
                                firebaseStorageManager.upload(uuid: uuidString, data: data, atPath: "/arquivos/" + uuidString) { url, time, error in
                                    if let error = error {
                                        print("Erro ao fazer upload: \(error.localizedDescription)")
                                    } else if let downloadURL = url {
                                        print("Upload bem-sucedido! URL de download: \(downloadURL.absoluteString)")
                                    }
                                    
                                    if let time = time {
                                        imagesViewModel.saveNewImage(name: uuidString, time: time, image: Image(uiImage: uiImage))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
        
    }
}

#Preview {
    ContentView()
}
