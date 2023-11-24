import Foundation
import SwiftUI
import UIKit

final class ViewModel: ObservableObject {
    @Published var highestScore: Int = 0
    @Published var score: Int = 0
    @Published var lives: Int = 5
    @Published var currentGuess: String = ""
    @Published var currentWord: String = ""
    @Published var scrambledCurrentWord: String = ""
    @Published var gameOver: Bool = false
    @Published var difficulty: String = ""
    @Published var keyValues: [[String]] = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                                            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                                            ["Z", "X", "C", "V", "B", "N", "M"]]
    var scoreSheet: [String: [Int]] = ["easy":[3, 4, 5, 6, 7],
                                        "medium": [8, 9, 10, 11, 12],
                                        "hard": [13, 14, 15, 16, 17],
                                        "extreme":[18, 19, 20, 21, 22]]
    
    var alreadyPicked: [String] = []
    
    init() {
        self.highestScore = UserDefaults.standard.integer(forKey: "highestScore")
    }
    
    func startGame(difficulty: String) {
        self.score = 0
        self.lives = 5
        self.alreadyPicked = []
        self.difficulty = difficulty
        resetBoard()
    }
    
    func checkWord() {
        if self.currentGuess.count == self.currentWord.count {
            if self.currentGuess == currentWord {
                if let scoreVal = scoreSheet[difficulty]?.randomElement()! {
                    self.score += scoreVal
                    updateHighestScore(newScore: self.score)
                    self.currentGuess = ""
                    resetBoard()
                    vibrate(.medium)
                }
            } else {
                if self.lives > 1 {
                    self.lives -= 1
                    resetBoard()
                    vibrate(.heavy)
                } else {
                    self.gameOver = true
                    vibrate(.heavy)
                    
                }
            }
        }
    }
    
    func resetBoard() {
        self.currentWord = pickRandomItem(from: self.difficulty, alreadyPicked: alreadyPicked) ?? ""
        self.scrambledCurrentWord = scramble()
        self.currentGuess = ""
    }
    
    func backspaceDelete() {
        if !self.currentGuess.isEmpty {
            self.currentGuess.remove(at: self.currentGuess.index(before: self.currentGuess.endIndex))
            vibrate(.light)
        }
    }
    
    func appendTextToCurrentGuess(_ text: String) {
        if self.currentGuess.count < self.currentWord.count {
            self.currentGuess += text.lowercased()
        }
    }
    
    func scramble()-> String {
        var chars = Array(self.currentWord)
        while chars == Array(self.currentWord) {
            chars.shuffle()
        }
        return String(chars)
    }
    
    
    func readCSVFile(column: String) -> [String] {
        if let filePath = Bundle.main.path(forResource: "words", ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filePath)
                let lines = contents.components(separatedBy: "\n")
                var columnData = [String]()
                var columnIndex: Int?
                if let headers = lines.first?.components(separatedBy: ",") {
                    columnIndex = headers.firstIndex(of: column)
                }
                if let columnIndex = columnIndex {
                    for line in lines {
                        let columns = line.components(separatedBy: ",")
                        if columns.count > columnIndex {
                            let value = columns[columnIndex]
                            if !value.isEmpty {
                                columnData.append(value)
                            }
                        }
                    }
                    return columnData
                }
            } catch {
                print("Error reading the CSV file: \(error)")
            }
        }
        print("Error finding or reading the CSV file or column not found.")
        return []
    }

    func pickRandomItem(from column: String, alreadyPicked: [String]) -> String? {
        let columnData = readCSVFile(column: column)
        guard let randomItem = columnData.randomElement() else {
            return nil
        }
        if alreadyPicked.contains(randomItem) {
            return pickRandomItem(from: column, alreadyPicked: alreadyPicked)
        } else {
            self.alreadyPicked.append(randomItem)
            return randomItem
        }
    }
    
    func updateHighestScore(newScore: Int) {
        if newScore > self.highestScore {
            self.highestScore = newScore
            UserDefaults.standard.set(self.highestScore, forKey: "highestScore")
        }
    }
    
    func vibrate(_ vibrationStrength: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: vibrationStrength)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
}
