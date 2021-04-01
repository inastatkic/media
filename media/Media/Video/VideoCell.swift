// Created by Ina Statkic in 2021.

import SwiftUI
import struct Kingfisher.KFImage

struct VideoCell: View {
    var video: Video
    @Binding var text: String
    
    var body: some View {
        HStack {
            KFImage(video.thumbnail).resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(video.title).font(.headline)
                Text(video.description).font(.caption).lineLimit(3)
            }
        }
    }
}

struct VideoCell_Previews: PreviewProvider {
    static var previews: some View {
        VideoCell(video: Video(id: "1", title: "Apple Event", description: "Watch the Apple Special Event"), text: .constant("")).previewLayout(.fixed(width: 300, height: 100))
    }
}
