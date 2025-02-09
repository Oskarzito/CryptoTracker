
import SwiftUI

struct HorizontalDetailsRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(value)
            }
            Divider()
                .background(.white.opacity(0.6))
        }
        .foregroundStyle(.white)
        .padding(.vertical, 8)
    }
}
