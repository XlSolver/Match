//
//  PlayerView.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct PlayerView: View {
    @Environment (\.modelContext) private var context
    @Bindable var player: Player
    
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            
            //Show and unwrapp the photo
            Section{
                if let selectedPhotoFromGallery = player.profilePicture,
                   let uiImage = UIImage(data: selectedPhotoFromGallery) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }
                
                Text("Hello, \(player.name) \(player.surname)!")
                
                //PhotoManage
                Section {
                    
                    //I think i would need to ask for permission
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label("New photo", systemImage: "photo")
                    }
                    
                    //delete selected photo
                    if player.profilePicture != nil {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                player.profilePicture = nil
                            }
                        } label: {
                            Label("Remove", systemImage: "xmark")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                    .navigationTitle("Your card")
                    //call for asynchronous code with task keyword to load an image from gallery
                    .task(id: selectedPhoto) {
                        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) { //wants to transform from "photo" to "data" file
                            player.profilePicture = data
                        }
                    }
            }
        }
    }
}

#Preview {
    PlayerView(player: Player(name: "Dino", surname: "Conta", age: 10, skillLevel: 4, profilePicture: Data()))
}
