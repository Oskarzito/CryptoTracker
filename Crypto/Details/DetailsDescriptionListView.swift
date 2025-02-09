
import SwiftUI

struct DetailsDescriptionListView: View {
    let name: String
    let symbol: String
    let id: String
    let marketCap: String
    let tags: [String]
    @Binding var showInfoSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HorizontalDetailsRow(title: "Name:", value: name)
            HorizontalDetailsRow(title: "Symbol:", value: symbol)
            HorizontalDetailsRow(title: "CoinMarketCap ID:", value: id)
            HorizontalDetailsRow(title: "Market Cap:", value: marketCap)
            
            DetailsTagsView(tags: tags)
            
            Button {
                showInfoSheet.toggle()
            } label: {
                Text("More info")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.15, green: 0.15, blue: 0.15)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
            .padding(.top, 24)
        }
    }
}
