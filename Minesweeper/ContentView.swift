//
//  ContentView.swift
//  Minesweeper
//
//  Created by Liu, Emily on 3/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var board: [[Square]] = Array(repeating: Array(repeating: Square(), count: 10), count: 10)
    @State private var gameStatus = "Tap to start"
    @State private var isGameOver = false

    var body: some View {
        VStack {
            Text(gameStatus)
                .padding()

            ForEach(0..<10, id: \.self) { row in
                HStack {
                    ForEach(0..<10, id: \.self) { col in
                        Button(action: {
                            if !isGameOver {
                                revealSquare(row, col)
                            }
                        }) {
                            Text(board[row][col].isRevealed ? "\(board[row][col].value)" : " ")
                                .frame(width: 30, height: 30)
                                .padding(5)
                                .background(board[row][col].isRevealed ? .gray : .blue)
                                .cornerRadius(5)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            Button(action: {
                startGame()
            }) {
                Text("New Game")
            }
            .padding()
        }
    }

    func revealSquare(_ row: Int, _ col: Int) {
        if !board[row][col].isRevealed {
            board[row][col].isRevealed = true

            if board[row][col].isMine {
                gameStatus = "Game Over - You hit a mine!"
                isGameOver = true
            } else {
                let adjacentMines = countAdjacentMines(row, col)
                if adjacentMines == 0 {
                    for i in -1...1 {
                        for j in -1...1 {
                            if isValidSquare(row + i, col + j) {
                                revealSquare(row + i, col + j)
                            }
                        }
                    }
                } else {
                    board[row][col].value = "\(adjacentMines)"
                }
            }
        }
    }

    func countAdjacentMines(_ row: Int, _ col: Int) -> Int {
        var count = 0
        for i in -1...1 {
            for j in -1...1 {
                if !(i == 0 && j == 0) && isValidSquare(row + i, col + j) && board[row + i][col + j].isMine {
                    count += 1
                }
            }
        }
        return count
    }

    func isValidSquare(_ row: Int, _ col: Int) -> Bool {
        return row >= 0 && row < 10 && col >= 0 && col < 10
    }

    func startGame() {
        // Reset board
        board = Array(repeating: Array(repeating: Square(), count: 10), count: 10)
        isGameOver = false
        gameStatus = "Tap to start"

        // Place mines randomly
        var minesPlaced = 0
        while minesPlaced < 10 {
            let row = Int.random(in: 0..<10)
            let col = Int.random(in: 0..<10)

            if !board[row][col].isMine {
                board[row][col].isMine = true
                minesPlaced += 1
            }
        }

        // Calculate adjacent mine counts
        for i in 0..<10 {
            for j in 0..<10 {
                if !board[i][j].isMine {
                    board[i][j].value = "\(countAdjacentMines(i, j))"
                }
            }
        }
    }
}

struct Square {
    var isMine = false
    var isRevealed = false
    var value = ""
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
