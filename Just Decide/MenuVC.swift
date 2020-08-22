//
//  MenuVC.swift
//  Just Decide
//
//  Created by James Jones on 27/07/2020.
//  Copyright © 2020 James Jones. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit


enum MenuType: Int {
    case home
}


class MenuVC: UITableViewController {

    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true) { [weak self] in
            print("dismissing \(menuType)")
            guard let self = self else {return}
            self.didTapMenuType?(menuType)
            
        }
        
    }

    @IBAction func shareButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle as Any)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        let activityVC = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        activityVC.popoverPresentationController?.canOverlapSourceViewRect = true
        present(activityVC, animated: true, completion: nil)
    
    }
    
    @IBAction func PrivacyButtonPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://james-n-jones.wixsite.com/jamesjones/post/privacy-policy-just-decide")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
       SKStoreReviewController.requestReview()
    }
    
    @IBAction func feedbackButtonPressed(_ sender: UIButton) {
        showMail()
    }
    
    func showMail() {
        guard MFMailComposeViewController.canSendMail() else {
                let alert = UIAlertController(title: "Something went wrong", message: "We cant access your email", preferredStyle: .alert)
                         let action = UIAlertAction(title: "OK", style: .default)
                         alert.addAction(action)
                         present(alert, animated: true)
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["james-n-jones@hotmail.com"])
        composer.setSubject("Feedback")
        
        present(composer, animated: true)
    }
}

extension MenuVC : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
        }
       
        switch result {
        case .cancelled:
            print("")
        case .saved:
            print("")
        case .sent:
                let alert = UIAlertController(title: "Thank You", message: "Your feedback is really appreciated!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                present(alert, animated: true)
                
                controller.dismiss(animated: true, completion: nil)
        case .failed:
            print("")
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
