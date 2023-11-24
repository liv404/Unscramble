import SwiftUI

struct GameView: View {
    @StateObject var vm = ViewModel()
    var difficulty: String
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    if !vm.gameOver {
                        Header(vm: vm)
                            .padding(.top, 40)
                        Spacer()
                        GameContent(vm: vm)
                        Spacer()
                    } else {
                        GameOver(vm: vm)
                    }
                }
            }
            .onAppear {
                vm.startGame(difficulty: difficulty)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(difficulty: "")
    }
}
