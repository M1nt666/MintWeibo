//
//  PostImageCell.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/20.
//

import SwiftUI

private let kImageSpace: CGFloat = 6

struct PostImageCell: View {
    
    let image: [String]
    let width: CGFloat
    
    var body: some View {
        if image.count == 1 {
            loadImage(name: image[0])
                .resizable()
                .scaledToFill()
                .frame(width: width, height: width * 0.75)
                .clipped()
        } else if image.count == 2 {
            PostImageCellRow(image: image, width: width)
        } else if image.count == 3 {
            PostImageCellRow(image: image, width: width)
        } else if image.count == 4 {
            VStack(spacing: kImageSpace) {
                PostImageCellRow(image: Array(image[0...1]), width: width)
                PostImageCellRow(image: Array(image[2...3]), width: width)
            }
        } else if image.count == 5 {
            VStack(spacing: kImageSpace) {
                PostImageCellRow(image: Array(image[0...1]), width: width)
                PostImageCellRow(image: Array(image[2...4]), width: width)
            }
        } else if image.count == 6 {
            VStack(spacing: kImageSpace) {
                PostImageCellRow(image: Array(image[0...2]), width: width)
                PostImageCellRow(image: Array(image[3...5]), width: width)
            }
        } else if image.count == 7 {
            VStack(spacing: kImageSpace) {
                PostImageCellRow(image: Array(image[0...2]), width: width)
                PostImageCellRow(image: Array(image[3...5]), width: width)
                PostImageCellRow(image: Array(image[6...6]), width: width)
            }
        }
    }
}

struct PostImageCellRow: View {
    let image: [String]
    let width: CGFloat
    
    var body: some View {
        HStack(spacing: kImageSpace) {
            ForEach(image, id: \.self) { image in
                loadImage(name: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (self.width - kImageSpace * CGFloat(self.image.count - 1)) / CGFloat(self.image.count), height: (self.width - kImageSpace * CGFloat(self.image.count - 1)) / CGFloat(self.image.count))
                    .clipped()
            }
        }
    }
}


struct PostImageCell_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData.testData
        let images = userData.recommendPostList.list[0].images
        let width = UIScreen.main.bounds.width
        
        PostImageCell(image: Array(images[0...0]), width: width)
        PostImageCell(image: Array(images[0...1]), width: width)
        PostImageCell(image: Array(images[0...5]), width: width)
    }
}
