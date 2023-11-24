import SwiftUI


struct WelcomeView: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    GameTitle()
                    Spacer()
                    DifficultyButtons(vm: vm)
                    Spacer()
                    HighestScore(vm: vm)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DifficultyButtons: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack(spacing: 25) {
            NavigationLink(destination: GameView(difficulty: "easy")) {
                DefaultButton(title: "Easy")
            }
            NavigationLink(destination: GameView(difficulty: "medium")) {
                DefaultButton(title: "Medium")
            }
            NavigationLink(destination: GameView(difficulty: "hard")) {
                DefaultButton(title: "Hard")
            }
            NavigationLink(destination: GameView(difficulty: "extreme")) {
                DefaultButton(title: "Extreme")
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
