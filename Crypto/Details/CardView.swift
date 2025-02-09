
import SwiftUI

struct CardView: View {
    let price: String
    let currency: String
    let selectedTimeInterval: CryptoTimeInterval
    let percentageChange: Double
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        // Not used since formatting becomes wrong
        // formatter.numberStyle = .percent
        formatter.positivePrefix = formatter.plusSign
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            VStack {
                HStack(alignment: .bottom) {
                    Text(price)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    Text(currency)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.bottom, 6)
                }
                
                HStack {
                    Text("Change in the past \(selectedTimeInterval.longName): ")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                    Text("\(formattedPercentageChange())%")
                        .font(.subheadline)
                        .foregroundStyle(percentageChange >= 0 ? .green : .red)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .cornerRadius(12)
        .shadow(color: .gray, radius: 6)
    }
    
    private func formattedPercentageChange() -> String {
        let value = percentageChange
        return formatter.string(for: value) ?? "0.00"
    }
}
