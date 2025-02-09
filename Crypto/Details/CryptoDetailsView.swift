
import SwiftUI
import Lottie

struct CryptoDetailsView: View {
    @EnvironmentObject var viewModel: CryptoDetailsViewModel
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @State var showContent: Bool = false
    @State var showInfoSheet: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if viewModel.isLoading {
                LottieView(animation: .named("fetching"))
                    .looping()
                    .frame(width: 250, height: 250)
                    .opacity(showContent ? 0 : 1)
                    .animation(.easeOut(duration: 0.5), value: !showContent)
            } else {
                DetailsContentView(showInfoSheet: $showInfoSheet)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : UIScreen.main.bounds.height)
                    .animation(.easeOut(duration: 0.9), value: showContent)
                    .navigationTitle(viewModel.cryptocurrency.name)
            }
        }
        .onAppear {
            viewModel.fetchCryptoData(for: mainViewModel.selectedCurrency)
        }
        .onChange(of: mainViewModel.selectedCurrency) {
            viewModel.fetchCryptoData(for: mainViewModel.selectedCurrency)
        }
        .onReceive(viewModel.$isLoading) { isLoading in
            withAnimation {
                // Show content if loading is done
                if !isLoading {
                    self.showContent = true
                } else {
                    self.showContent = false
                }
            }
        }
        .sheet(isPresented: $showInfoSheet) {
            NavigationStack {
                MoreInfoView()
                    .navigationBarItems(
                        trailing: Button(
                            "Close",
                            action: { showInfoSheet.toggle() }
                        )
                    )
                    .environmentObject(MoreInfoViewModel(cryptoId: viewModel.cryptoListing!.id))
            }
        }
    }
}

#Preview {
    CryptoDetailsView()
        .environmentObject(CryptoDetailsViewModel(cryptocurrency: MainViewModel.dummyData.first!))
        .environmentObject(MainViewModel(cryptoList: MainViewModel.dummyData, isDebug: true))
}
