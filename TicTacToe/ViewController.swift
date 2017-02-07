//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jim Campagno on 2/5/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BoardDelegate {
    
    @IBOutlet weak var boardZero: Board!
    @IBOutlet weak var boardOne: Board!
    @IBOutlet weak var boardTwo: Board!
    
    @IBOutlet weak var boardThree: Board!
    @IBOutlet weak var boardFour: Board!
    @IBOutlet weak var boardFive: Board!
    
    @IBOutlet weak var boardSix: Board!
    @IBOutlet weak var boardSeven: Board!
    @IBOutlet weak var boardEight: Board!
    
    @IBOutlet weak var winLabel: UILabel!
    
    var letterNum: Int = 1
    var allBoards: [Board] {
        return [boardZero, boardOne, boardTwo, boardThree, boardFour, boardFive, boardSix, boardSeven, boardEight]
    }
    
    
    var firstMove = true //evaluate if its the first move, could've sworn this was used, but it doesn't appear to be anywhere else; possibly remove?
    var posBoolDict : [Int : Bool] = [:] //[Position : T/F]
    var boardPosBoolDict : [Int : [Int : Bool]] = [:] //[Board : [Position : T/F]]
    var populateDictionaries = true // Determine if all dictionaries and arrays have been built on startup
    var openBoards : [Int : Bool] = [:] // [Board : T/F] - used to what boards have been completed
    
    let winCombos : [[Int]] = [
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,8],
        [6,4,2]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        if populateDictionaries {
            for num in 0...8 {
                posBoolDict[num] = false
                openBoards[num] = true
            }
            
            for num in 0...8 {
                boardPosBoolDict[num] = posBoolDict
            }
            populateDictionaries = false
        }
    }
    
    func initialSetup() {
        var boardPosition = 0
        for board in allBoards {
            board.position = boardPosition
            board.delegate = self
            boardPosition += 1
        }
    }
    
    func playerTurn(board: Board, position: Int) -> Player {
        
        board.xArray.append(position)
        self.didWinBoard(board: board, player: .x)
        self.didWinGame(board: board)
        populateBoolValues(board: board, position: position)
        highlightBoard(position: position, boards: allBoards)
        return .x
    }
    
    func playDidFinish() {
        
        var boardIndex = Int(arc4random_uniform(9))
        var positionIndex = Int(arc4random_uniform(9))
        
        while (boardPosBoolDict[boardIndex]?[positionIndex])! || !openBoards[boardIndex]! || allBoards[boardIndex].alpha == 0.25 {
            boardIndex = Int(arc4random_uniform(9))
            positionIndex = Int(arc4random_uniform(9))
        }
        
        let currentBoard = allBoards[boardIndex]
        let imageVivew = currentBoard.all[positionIndex]
        
        currentBoard.animateTurn(imageView: imageVivew, player: .o)
        
        populateBoolValues(board: currentBoard, position: positionIndex)
        
        currentBoard.oArray.append(positionIndex)
        self.didWinBoard(board: currentBoard, player: .o)
        self.didWinGame(board: currentBoard)
        self.highlightBoard(position: positionIndex, boards: allBoards)
    }

    func didWinBoard (board: Board, player: Player) {
        
        let xList = board.xArray
        let oList = board.oArray
        
        for combo in winCombos {
            
            let findList = combo
            
            let xListSet = NSSet(array: xList)
            let oListSet = NSSet(array: oList)
            
            let findListSet = NSSet(array: findList)
            
            let allXElementsContained = findListSet.isSubset(of: xListSet as! Set<AnyHashable>)
            let allOElementsContained = findListSet.isSubset(of: oListSet as! Set<AnyHashable>)
            
            if allXElementsContained {
                board.win(for: player)
                board.won = "x"
                openBoards[board.position] = false
                return
            } else if allOElementsContained {
                board.win(for: player)
                board.won = "o"
                openBoards[board.position] = false
                return
            }
        }
    }
    
    func didWinGame(board: Board) {
        var boardDict : [Int : String] = [:]

        for board in allBoards {
            
            switch board {
            case boardZero:
                boardDict[0] = boardZero.won
            case boardOne:
                boardDict[1] = boardOne.won
            case boardTwo:
                boardDict[2] = boardTwo.won
            case boardThree:
                boardDict[3] = boardThree.won
            case boardFour:
                boardDict[4] = boardFour.won
            case boardFive:
                boardDict[5] = boardFive.won
            case boardSix:
                boardDict[6] = boardSix.won
            case boardSeven:
                boardDict[7] = boardSeven.won
            case boardEight:
                boardDict[8] = boardEight.won
            default:
                print("Default")
            }
        }
        
        func removeBoards() {
            for board in allBoards {
                board.alpha = 0
            }
        }
        
        for combo in winCombos {
            if boardDict[combo[0]] == "x" && boardDict[combo[1]] == "x" && boardDict[combo[2]] == "x" {
                removeBoards()
                winLabel.text = "X wins the Game"
                return
            } else if boardDict[combo[0]] == "o" && boardDict[combo[1]] == "o" && boardDict[combo[2]] == "o" {
                removeBoards()
                winLabel.text = "O wins the Game"
                return
            }
        }
    }
    
    func highlightBoard(position: Int, boards: [Board]) {

        for num in 0...8 {
            allBoards[num].alpha = 0.25
            allBoards[num].isUserInteractionEnabled = false
            if num == position {
                allBoards[num].alpha = 1
                allBoards[num].isUserInteractionEnabled = true
            }
        }
        
        if !openBoards[position]! {
            for board in allBoards {
                board.alpha = 1
                board.isUserInteractionEnabled = true
            }
        }
    }
    
    func populateBoolValues(board: Board, position: Int) {
        boardPosBoolDict[board.position]?[position] = true
    }
}
