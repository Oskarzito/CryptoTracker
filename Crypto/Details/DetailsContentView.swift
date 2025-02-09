
import SwiftUI

struct DetailsContentView: View {
    @State private var position = CGPoint.zero
    
    @EnvironmentObject var viewModel: CryptoDetailsViewModel
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @Binding var showInfoSheet: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                CardView(
                    price: viewModel.formattedPrice(
                        currency: mainViewModel.selectedCurrency
                    ),
                    currency: mainViewModel.selectedCurrency,
                    selectedTimeInterval: viewModel.selectedTimeInterval,
                    percentageChange: viewModel.percentageChange
                )
                .padding(.horizontal, 16)
                .frame(height: 200)
                .modifier(DragRotationModifier(position: $position))
                
                Picker("", selection: $viewModel.selectedTimeInterval) {
                    ForEach(viewModel.timeIntervals, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .onChange(of: viewModel.selectedTimeInterval) {
                    viewModel.updatePercentageChange(for: mainViewModel.selectedCurrency)
                }
                .pickerStyle(.segmented)
                .padding(.top, 24)
                .padding(.horizontal, 16)
                
                Picker("", selection: $mainViewModel.selectedCurrency) {
                    ForEach(mainViewModel.currencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 24)
                .padding(.horizontal, 16)
                
                if let cryptoListing = viewModel.cryptoListing {
                    DetailsDescriptionListView(
                        name: cryptoListing.name,
                        symbol: cryptoListing.symbol,
                        id: "\(cryptoListing.id)",
                        marketCap: viewModel.marketCap(
                            currency: mainViewModel.selectedCurrency
                        ),
                        tags: cryptoListing.tags,
                        showInfoSheet: $showInfoSheet
                    )
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}
