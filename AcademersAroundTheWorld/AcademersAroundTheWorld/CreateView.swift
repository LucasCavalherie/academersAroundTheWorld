//
//  CreateView.swift
//  AcademersAroundTheWorld
//
//  Created by Lucas Cavalherie on 01/10/23.
//

import SwiftUI
import PhotosUI

struct CreateView: View {
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var title: String = ""
    var firebaseStorageManager = FirebaseStorageManager()
    @ObservedObject var imagesViewModel = ImagesViewModel.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    var body: some View {
        NavigationStack {
            VStack  {
                
                Image("Top")
                
                Text("Seleção de Imagens")
                    .font(.title2)
                    .padding()
                
                VStack (alignment: .leading) {
                    Text("(Opcional)")
                        .font(.caption)
                    Text("Título da imagem: ")
                    TextField("Enter your name", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    VStack (alignment: .leading) {
                        Text("Quantidade de imagens selecionadas: \(selectedItems.count)")
                        
                        HStack {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                HStack {
                                    Text("Cancelar")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(.gray)
                                .cornerRadius(10)
                            }
                            
                            Spacer()
                            
                            if selectedItems.count > 0 {
                                Button {
                                    sendImages()
                                    self.presentationMode.wrappedValue.dismiss()
                                } label: {
                                    HStack {
                                        Image(systemName: "paperplane.fill")
                                        Text("Enviar fotos")
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .background(Color("Blue"))
                                    .cornerRadius(10)
                                }
                            } else {
                                PhotosPicker(selection: $selectedItems, matching: .images) {
                                    HStack {
                                        Text("Selecionar fotos")
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .background(Color("Blue"))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    
                }
                .padding()
                
                Spacer()
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
        }
        
    }
    
    func sendImages(){
        Task {
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        let uuidString : String = UUID().description
                        firebaseStorageManager.upload(title: title, uuid: uuidString, data: data, atPath: "/arquivos/" + uuidString) { url, time, error in
                            if let error = error {
                                print("Erro ao fazer upload: \(error.localizedDescription)")
                            } else if let downloadURL = url {
                                print("Upload bem-sucedido! URL de download: \(downloadURL.absoluteString)")
                            }
                            
                            if let time = time {
                                imagesViewModel.saveNewImage(title: title, name: uuidString, time: time, image: Image(uiImage: uiImage))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CreateView()
}
