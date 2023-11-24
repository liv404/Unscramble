import SwiftUI


struct BackgroundView: View {
    var body: some View {
        Color(.background)
            .edgesIgnoringSafeArea(.all)
    }
}


struct DefaultButton: View {
    var title: String
    
    var body: some View{
        Text(title)
            .frame(width: 200, height: 50)
            .background(Color(.font))
            .font(.system(size: 20, weight: .bold))
            .cornerRadius(10)
            .foregroundColor(Color(.background))
    }
}


struct GameTitle: View {
    var body: some View {
        Text("Unscramble!")
            .font(.system(size: 40, weight: .bold))
            .padding(.top, 50)
            .foregroundColor(Color(.font))
    }
}


struct HighestScore: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        HStack {
            Text("Highest Score: \(vm.highestScore)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(.font))
        }
    }
}


struct Score: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        Text("\(vm.score)")
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(Color(.font))
    }
}


struct Hearts: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        HStack {
            // lost lives
            ForEach((vm.lives..<5), id: \.self) { heart in
                Image(systemName: "heart")
                    .fontWeight(.bold)
                    .foregroundColor(Color(.font))
            }
            // lives
            ForEach((0..<vm.lives), id: \.self) { heart in
                Image(systemName: "heart.fill")
                    .fontWeight(.bold)
                    .foregroundColor(Color(.font))
            }
        }
        .frame(width: 150, height: 30)
    }
}


struct HomeButton: View {
    var height: CGFloat
    var width: CGFloat
    
    var body: some View{
        NavigationLink(destination: WelcomeView()){
            Image(systemName: "house")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .foregroundColor(Color(.font))
        }
    }
}


struct GameOver: View{
    @ObservedObject var vm: ViewModel
    
    var body: some View{
        VStack {
            Score(vm: vm)
                .padding(.top, 30)
                .padding(.bottom, 100)
            VStack (spacing: 60) {
                Text("Game Over!")
                    .font(.system(size: 40, weight: .bold))
                HomeButton(height: 150, width: 150)
                NavigationLink(destination: GameView(difficulty: vm.difficulty)) {
                    DefaultButton(title: "Try Again")
                }
            }
            Spacer()
            HighestScore(vm: vm)
                .padding(.bottom, 20)
        }
    }
}


struct Header: View {
    @ObservedObject var vm: ViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                HStack {
                    HomeButton(height: 20, width: 20)
                    HighestScore(vm: vm)
                }
                .frame(maxWidth: geometry.size.width, alignment: .center)
                Score(vm: vm)
                Hearts(vm: vm)
            }
        }
    }
}


struct SpecialKey_Keyboard: View {
    var imageName: String
    var valueSize: CGFloat
    var backgroundColour: Color?
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColour)
                .frame(width: 40, height: 45)
                .cornerRadius(5.0)
            Image(systemName: imageName)
                .font(.system(size: valueSize, weight: .bold))
                .foregroundColor(Color(.background))
        }
    }
}


struct IndividualKeys: View {
    @ObservedObject var vm: ViewModel
    var text: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(.font))
                .frame(width: 30, height: 45)
                .cornerRadius(5.0)
            Text(text)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(.background))
        } .onTapGesture {
            vm.appendTextToCurrentGuess(text)
        }
    }
}

struct Keyboard: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 7) {
                ForEach((0..<10), id: \.self ){ i in
                    IndividualKeys(vm: vm, text: vm.keyValues[0][i])
                }
            }
            HStack(spacing: 7) {
                ForEach((0..<9), id: \.self ){ i in
                    IndividualKeys(vm: vm, text: vm.keyValues[1][i])
                }
            }
            HStack(spacing: 7) {
                SpecialKey_Keyboard(imageName: "checkmark.square", valueSize: 20, backgroundColour: .green)
                    .onTapGesture {
                        vm.checkWord()
                    }
                ForEach((0..<7), id: \.self ){ i in
                    IndividualKeys(vm: vm, text: vm.keyValues[2][i])
                }
                SpecialKey_Keyboard(imageName: "delete.backward", valueSize: 20, backgroundColour: .red)
                    .onTapGesture {
                        vm.backspaceDelete()
                    }
            }
        }
    }
}


struct Word: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        Text(vm.scrambledCurrentWord)
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(Color(.font))
    }
}


struct GameContent: View {
    @State private var guess: String = ""
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Word(vm: vm)
            Spacer()
            Text(vm.currentGuess)
                .font(.system(size: 25, weight: .medium))
                .padding(.top, 30)
            HStack(alignment: .lastTextBaseline){
                Button {
                    vm.resetBoard()
                } label: {
                    Text("Skip")
                        .frame(width: 60, height: 30)
                        .font(.system(size: 20, weight: .light))
                        .background(Color(.font))
                        .cornerRadius(10)
                        .foregroundColor(Color(.background))
                        
                }
            }
            Keyboard(vm: vm)
                .padding(.bottom, 50)
        }
    }
}
