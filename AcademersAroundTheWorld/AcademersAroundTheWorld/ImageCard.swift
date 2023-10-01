//
//  ImageCard.swift
//  AcademersAroundTheWorld
//
//  Created by Henrique Semmer on 30/09/23.
//

import SwiftUI

struct ImageCard: View {
    @State var imageModel: ImageModel
    var deletarImagem: () -> Void
    
    var body: some View {
        VStack (alignment: .leading) {
            imageModel.image
                .resizable()
                .cornerRadius(10)
                .scaledToFit()
                .frame(width: 300, height: 200)
            
            HStack{
                VStack (alignment: .leading) {
                    Text(imageModel.title)
                        .font(.callout)
                        .foregroundColor(.primary)
                    
                    Text("\(imageModel.time.getTimeInterval())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    deletarImagem()
                } label: {
                    Image(systemName: "trash")
                }
            }
            .padding(.vertical, 4)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("Gray"), lineWidth: 3)
        )
        .cornerRadius(10)
        .padding(.vertical, 8)
    }
}

#Preview {
    ImageCard(imageModel: ImageModel(title: "a", name: "a", time: Date(), image: Image("a"))){
        print("a")
    }
    .frame(maxWidth: 300)
}
