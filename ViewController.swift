//
//  ViewController.swift
//  MasterMindGame(Assignment 1)
//
//  Created by Ope Omiwade on 05/11/2021.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    let colourArray = ["red","blue","green","orange","grey","yellow"]
    var secretCode = ["","","",""]
    var userCode = ["","","",""]
    var positionOfImageView = 0;
    var allGuesses = [[String]]() //stores all user guesses
    var noOfPlayerWins = 0
    var noOfMasterwins = 0
    var allowOkButton = false // to allow user press the ok button
    var blackandwhiteblobs = ["","","",""]
    var workingCopySecretCode = ["","","",""] // secretcode duplicate used when checking fro exact and partial matches
    var workingCopyUserGuess =  ["","","",""] // usercode duplicate used when checking fro exact and partial matches
    
    var numberOfGuesses = 0//player is only allowed ten guesses
    
    @IBOutlet weak var masterOutputMessage: UILabel!
    @IBOutlet weak var playerOutputMessage: UILabel!
    @IBOutlet weak var currentGuess1: UIImageView!
    @IBOutlet weak var currentGuess2: UIImageView!
    @IBOutlet weak var currentGuess3: UIImageView!
    @IBOutlet weak var currentGuess4: UIImageView!
    @IBOutlet weak var myTable: UITableView!
    var currentGuess:[UIImageView] = []
    var feedbackPegs : [UIImageView] = []
    
    @IBAction func allButtons(_ sender: UIButton) {
        if(sender.tag == 1){
            setImage("red")
        }
        
        else if(sender.tag == 2){
            setImage("blue")
        }
        
        else if (sender.tag == 3){
            setImage("green")
        }
        
        else if (sender.tag == 4){
            setImage("grey")
        }
        
        else if(sender.tag == 5){
            setImage("orange")
        }
        
        else if (sender.tag == 6){
            setImage("yellow")
        }
        
        else if(sender.tag == 7){//delete button
            if(positionOfImageView > 0){
                allowOkButton = false // do not allow user press ok button when they start deleting images
                currentGuess[positionOfImageView - 1].image = nil
                userCode[positionOfImageView - 1] = " "
                positionOfImageView = positionOfImageView - 1
            }
        }
        
        else if (sender.tag == 8 && allowOkButton == true){//ok button
            
            if(userCode == secretCode){
                noOfPlayerWins = UserDefaults.standard.integer(forKey: "playerGamesWon")
                noOfPlayerWins += 1
                UserDefaults.standard.set(noOfPlayerWins, forKey: "playerGamesWon")
                playerOutputMessage.text = String(noOfPlayerWins)
                let winAlert = UIAlertController(title: "You beat the master", message: "Do you wish to play again?", preferredStyle:.alert)
                winAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{action in
                    self.restartGame()// restarts the game
                }))
                winAlert.addAction(UIAlertAction(title: "No", style: .default, handler:{action in
                    self.performSegue(withIdentifier: "returntoInitialVC", sender: nil)
                }))
                self.present(winAlert,animated: true)
            }
            
            else if (numberOfGuesses < 9){// continue game if user guesses are less than 10
                //print(userCode)
                allGuesses.append(userCode)
                clearImageViews()
                numberOfGuesses += 1
                positionOfImageView = 0// reset position for new entry
                // print(numberOfGuesses)
                myTable.reloadData()
            }
            
            else if(numberOfGuesses >= 9 ){ //end game if the user guesses are more than 10
                noOfMasterwins = UserDefaults.standard.integer(forKey: "masterGamesWon")
                noOfMasterwins += 1
                UserDefaults.standard.set(noOfMasterwins, forKey: "masterGamesWon")
                masterOutputMessage.text = String(noOfMasterwins)
                let lossAlert = UIAlertController(title: "You lose", message: "You have no more guesses,do you want to try again?", preferredStyle:.alert)
                lossAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{action in
                    self.restartGame()
                }))
                lossAlert.addAction(UIAlertAction(title: "No", style: .default, handler:{action in
                    self.performSegue(withIdentifier: "returntoInitialVC", sender: nil)
                }))
                self.present(lossAlert, animated: true)
            }
        allowOkButton = false
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return numberOfGuesses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MasterMindViewCell
        let previousUserGuess = allGuesses[indexPath.row]
        let checkblackbobandwhiteblob = checkForBlackBlobandWhiteBlob(allGuesses[indexPath.row])
        if(!(previousUserGuess.isEmpty)){
            cell.ImageView1.image = UIImage(named:previousUserGuess[0])
            cell.ImageView2.image = UIImage(named:previousUserGuess[1])
            cell.ImageView3.image = UIImage(named:previousUserGuess[2])
            cell.ImageView4.image = UIImage(named:previousUserGuess[3])
        }
        if (!(checkblackbobandwhiteblob.isEmpty)){
            cell.bobImageView1.image = UIImage(named: checkblackbobandwhiteblob[0])
            cell.bobImageView2.image = UIImage(named: checkblackbobandwhiteblob[1])
            cell.bobImageView3.image = UIImage(named: checkblackbobandwhiteblob[2])
            cell.bobImageView4.image =  UIImage(named: checkblackbobandwhiteblob[3])
        }
        return cell
    }
    
    
    func setImage( _ colour: String){ // helper method to assign image view to correct colored peg
        if (positionOfImageView < 4){
            if(currentGuess[positionOfImageView].image == nil){
                currentGuess[positionOfImageView] .image = UIImage(named: colour)
                userCode[positionOfImageView] = colour
                positionOfImageView += 1
            }
            
            if(positionOfImageView == 4){//ensures user doesnt confirm a cell with less tahn 4 colored pegs
                allowOkButton = true
            }
        }
    }
    
    
    func clearImageViews(){//clears allimages of current guess for new entry
            for i in 0 ... 3 {
                currentGuess[i].image = nil
                userCode[i] = ""
            }
    }
    
    func makeSecretCode() -> [String]{//method to make secretcode
        var masterGuess = [String]()
        for _ in 0 ... 3{
            masterGuess.append(colourArray.randomElement()!)
        }
        print("Secret Code is :\(masterGuess)")
        return masterGuess
    }
    
    func checkForBlackBlobandWhiteBlob(_ userguess: [String]) -> [String]{// checks for exact and partial matches.
        workingCopyUserGuess = userguess // duplicate array containing user guess which is modified in this method
        for i in 0 ... 3{
            if(workingCopySecretCode.contains(workingCopyUserGuess[i])){// checks if user entry is in the secret code array
                if(workingCopyUserGuess[i] == workingCopySecretCode[i]){ // checks for exact match
                    blackandwhiteblobs[i] = "black blob"
                    workingCopySecretCode[i] = "++" // so it cant be matched again
                    workingCopyUserGuess[i] = "==" // impossible for this to be a match with anything
                }
                
                else{ // no exact match was found so it checks for a partial match
                    for j in 0 ... 3{
                        for i in 0 ... 3{
                            if (j != i){
                                if (workingCopySecretCode[j] == workingCopyUserGuess[i]) {
                                    blackandwhiteblobs[i] = "white blob"
                                    workingCopySecretCode[j] = "++" //so it cant be matched again
                                    break
                                }
                            }
                        }
                    }
                }
            }
            
            else{ // user entry isnt in the secretcode array
                blackandwhiteblobs[i] = " "
            }
            workingCopySecretCode = secretCode // reset working copy for next iteration.
        }
        //print (blackandwhiteblobs)
        return blackandwhiteblobs
    }
    
    func restartGame(){ // helper method to restart the game.
        allGuesses.removeAll()
        numberOfGuesses = 0
        userCode = ["","","",""]
        positionOfImageView = 0
        allowOkButton = false
        clearImageViews()
        secretCode = makeSecretCode() // make secret code for new game
        workingCopySecretCode = secretCode
        myTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentGuess.append(currentGuess1)
        currentGuess.append(currentGuess2)
        currentGuess.append(currentGuess3)
        currentGuess.append(currentGuess4)
        secretCode = makeSecretCode()// create secretcode for game
        workingCopySecretCode = secretCode
        masterOutputMessage.text = String(UserDefaults.standard.integer(forKey: "masterGamesWon"))//displays master wins on opening of the app
        playerOutputMessage.text = String(UserDefaults.standard.integer(forKey: "playerGamesWon"))//displays player wins on opening of the app
        
        // Do any additional setup after loading the view.
    }
}


