//
//  ViewController.swift
//  ProteinCase
//
//  Created by Cem Eke on 7.11.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var validUsernames = ["9nd54", "v542w", "17pcy0", "gbf48", "zdah4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func loginTapped() {
        if validUsernames.contains(txtUsername.text ?? "") {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FriendListVC") as? FriendListVC
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let alert = UIAlertController(title: "Username not found", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default ))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

