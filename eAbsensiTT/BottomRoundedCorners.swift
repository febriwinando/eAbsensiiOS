import SwiftUI

// Custom Shape hanya membulatkan sudut bawah kiri dan kanan
struct BottomRoundedCorners: Shape {
    var radius: CGFloat = 25.0 // Radius sudut membulat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomLeft, .bottomRight], // Membulatkan hanya sudut bawah
            cornerRadii: CGSize(width: radius, height: radius) // Ukuran radius
        )
        return Path(path.cgPath)
    }
}
