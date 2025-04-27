//
//  CustomAsyncImage.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/26/25.
//
import SwiftUI

struct CustomAsyncImage<Content: View, Placeholder: View>: View {
    
    @State var uiImage: UIImage?
    let fileId: String
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    init(
        _ fileId: String,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ){
        print("doing image init")
        self.fileId = fileId
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let uiImage = uiImage {
            content(Image(uiImage: uiImage))
        }else {
            placeholder()
                .task {
                    self.uiImage = await getImage(fileId: fileId)
                }
        }
    }

    func getImage(fileId: String) async -> UIImage {
        print("requesting image")
        let res =  await RecipeService.shared.getImage(fileId: fileId)
        switch res {
            case .success(let image):
            return image
        case .failure:
            return UIImage()
        }
    }
}



