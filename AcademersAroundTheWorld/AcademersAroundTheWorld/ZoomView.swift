//
//  ZoomView.swift
//  AcademersAroundTheWorld
//
//  Created by Lucas Cavalherie on 01/10/23.
//

import SwiftUI

struct ZoomView: View {
    @State var imageModel: ImageModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    Text(imageModel.title)
                        .font(.callout)
                        .foregroundColor(.primary)
                    
                    Text("\(imageModel.time.getTimeInterval())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                imageModel.image
                    .resizable()
                    .cornerRadius(10)
                    .scaledToFit()
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Voltar")
                    }
                }
            }
        }
        
        
        
    }
}

#Preview {
    ZoomView(imageModel: ImageModel(title: "a", name: "a", time: Date(), image: Image("Example")))
}
