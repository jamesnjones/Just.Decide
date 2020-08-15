//
//  ViewController.swift
//  Just Decide
//
//  Created by James Jones on 09/07/2020.
//  Copyright © 2020 James Jones. All rights reserved.
//

import UIKit
import TTFortuneWheel
import AVFoundation


class ViewController: UIViewController, UINavigationControllerDelegate {
 
    @IBOutlet weak var spinningWheel: TTFortuneWheel!
    @IBOutlet weak var ResultsLabel: UILabel!
    
    let transition = SlideInTransition()
    
    var slices : [CarnivalWheel] = []
    var result: String?
    
    var player: AVAudioPlayer!
    var soundIsOn = true
    var musicPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        self.navigationController?.delegate = self
        spinningWheel.initialDrawingOffset = 270.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
       
        slices = getSlices()
        updateUI()
        self.ResultsLabel.text = ""
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
               if slices.isEmpty {
                   instructions()
               }else {
                   return
               }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
        self.spinningWheel.stopAnimating()
            if self.musicPlaying{
                self.player.stop()
            }
        }
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
      }
      
      func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
      }
    
    private func updateUI() {
        spinningWheel.setNeedsDisplay()
               spinningWheel.setNeedsLayout()
                 spinningWheel.slices = slices
                          spinningWheel.equalSlices = true
                          spinningWheel.frameStroke.width = 1
                          spinningWheel.titleRotation = CGFloat.pi
                          spinningWheel.slices.enumerated().forEach { (pair) in
                              let slice = pair.element as! CarnivalWheel
                              let offset = pair.offset
                              switch offset % 6 {
                              case 0: slice.style = .blue
                              case 1: slice.style = .purple
                              case 2: slice.style = .orange
                              case 3: slice.style = .grey
                              case 4: slice.style = .green
                              default: slice.style = .yellow
                              }
                         
                          }
               
    }
   private func getSlices() -> [CarnivalWheel] {
        PersistenceManager.retrieveSlices { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let slices):
                if slices.isEmpty {
                    print("this is where i will add an alert or sumin")
                }else {
                    self.slices = slices
                    DispatchQueue.main.async {
                        self.reloadInputViews()
                    }
                }
                
            case .failure:
                print("Edit VC Errror ")
            }
        }
    
        return slices
       
    }
    
    func instructions() {
       
        let alert = UIAlertController(title: "Hello", message: "Click on the Edit button to add selections", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    

    @IBAction func rotateButton(_ sender: UIButton) {
   
        if soundIsOn {
            musicPlaying = true
        }else {
            musicPlaying = false
        }
        
        
        if soundIsOn {
        playSound(soundName: "spinning")
         spin()
        } else {spin()}
    }
    
    
    private func spin() {
            ResultsLabel.text = ""
            let randomNumber = Int.random(in: 0...slices.count - 1)
            spinningWheel.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.spinningWheel.startAnimating(fininshIndex: randomNumber) { (finished) in
                    self.ResultsLabel.text = self.spinningWheel.slices[randomNumber].title
                    
                    }
            }
    }
    
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: ".mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
   
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "MenuViewController") else {return}
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.transitioningDelegate = self
        present(viewController, animated: true)

    }
    
    @IBAction func soundButtonClicked(_ sender: UIButton) {
        soundIsOn = !soundIsOn
        if soundIsOn{
        sender.setImage(UIImage(named: "soundOn"), for: .normal)
        } else if !soundIsOn {
            sender.setImage(UIImage(named: "soundOff"), for: .normal)
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false 
        return transition
    }
}



