//
//  MenuVC.swift
//  Just Decide
//
//  Created by James Jones on 27/07/2020.
//  Copyright © 2020 James Jones. All rights reserved.
//

import UIKit

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
        
        UIApplication.shared.open(URL(string: "http://www.apple.com")! as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func feedbackButtonPressed(_ sender: UIButton) {
    }
    
    
}
