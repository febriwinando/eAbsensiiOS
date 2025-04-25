
import SwiftUI

struct ImageDisplayView: View {
    var selectedImage: UIImage

    var body: some View {
        VStack {
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFit()
                .padding()
                .navigationTitle("Captured Image")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
