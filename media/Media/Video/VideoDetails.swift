// Created by Ina Statkic in 2021.

import SwiftUI
import struct Kingfisher.KFImage

struct VideoDetails: View {
    let video: Video
    
    var body: some View {
        ScrollView {
            VStack {
                KFImage(video.image).resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                VStack(alignment: .leading) {
                    Text(video.title).font(.title).lineLimit(nil)
                    Text(video.description).lineLimit(nil)
                }.padding(.horizontal)
            }
        }
    }
}

struct VideoDetails_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetails(video: Video(id: "1", title: "Apple Event", description: "Watch the Apple Special Event"))
    }
}
