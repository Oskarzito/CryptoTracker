
import SwiftUI
import Lottie

struct MoreInfoView: View {
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var viewModel: MoreInfoViewModel
    @State var showContent: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if viewModel.isLoading {
                LottieView(animation: .named("bitcoin-loading"))
                    .looping()
                    .frame(width: 250, height: 250)
                    .opacity(showContent ? 0 : 1)
                    .animation(.easeOut(duration: 0.5), value: !showContent)
            } else {
                List {
                    HStack {
                        Spacer()
                        LottieView(animation: .named("bitcoin-loading"))
                            .playing()
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 32)
                    
                    ForEach(Array(viewModel.metadata.keys), id: \.self) { key in
                        if let value = viewModel.metadata[key] {
                            // TODO: Highlight rows on tap
                            HorizontalDetailsRow(title: key, value: value)
                                .onTapGesture {
                                    if let url = URL(string: value) {
                                        openURL(url)
                                    }
                                }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            viewModel.fetchCryptoMetaData()
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
    }
}

#Preview {
    MoreInfoView()
        .environmentObject(MoreInfoViewModel(cryptoId: 1))
}
