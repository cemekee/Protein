//
//  FriendListVC.swift
//  ProteinCase
//
//  Created by Cem Eke on 7.11.2021.
//

import UIKit

class FriendListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = FriendListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.fetchUsers()
        
        viewModel.updateUI = {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
}

extension FriendListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let friend = viewModel.friendList[indexPath.row]
        cell.textLabel?.text = (friend.name?.title)! + " " + (friend.name?.first)! + " " + (friend.name?.last)!
      return cell
    }
    
    
}
extension FriendListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DetailVC") as? DetailVC
            vc!.friendDetail = self.viewModel.friendList[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}


