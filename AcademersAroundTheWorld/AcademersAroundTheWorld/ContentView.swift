//
//  ContentView.swift
//  AcademersAroundTheWorld
//
//  Created by Lucas Cavalherie on 29/09/23.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    var firebaseStorageManager = FirebaseStorageManager()
    @ObservedObject var imagesViewModel = ImagesViewModel.shared
    @State private var isDeleteConfirmationVisible = false
    @State private var showingSheet = false
    @State private var showingImage: ImageModel = ImageModel(title: "", name: "", time: Date(), image: Image(""))

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
                    
                    NavigationLink {
                        CreateView()
                    } label: {
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
                        let image = imagesViewModel.images[i]
                        
                        Button {
                            showingImage = image
                            showingSheet.toggle()
                        } label: {
                            ImageCard(imageModel: image) {
                                isDeleteConfirmationVisible.toggle()
                            }
                            .alert(isPresented: $isDeleteConfirmationVisible) {
                                // Modal de confirmação
                                Alert(
                                    title: Text("Confirmar exclusão"),
                                    message: Text("Tem certeza de que deseja excluir esta imagem?"),
                                    primaryButton: .destructive(Text("Excluir")) {
                                        Task {
                                            firebaseStorageManager.delete(atPath: "/arquivos/\(image.name)") { error in
                                                if let error = error {
                                                    print("Erro ao fazer delete: \(error.localizedDescription)")
                                                }
                                            }
                                        }
                                        
                                        imagesViewModel.images.removeAll(where: {$0.name == image.name})
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            .padding(.horizontal, 32)
                        }
                        .sheet(isPresented: $showingSheet) {
                            ZoomView(imageModel: showingImage)
                        }
                        
                    }
                }
                .padding(.bottom, 16)
            }
            .ignoresSafeArea()
        }
        
    }
}

#Preview {
    ContentView()
}
