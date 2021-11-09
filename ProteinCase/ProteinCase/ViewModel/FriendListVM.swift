//
//  FriendListVM.swift
//  ProteinCase
//
//  Created by Cem Eke on 7.11.2021.
//

import UIKit

class FriendListVM {
    
    var friendList = [Friend]()
    var updateUI : ()->() = {}
    
    func fetchUsers() {
        Service.instance.request("https://randomuser.me/api/?results=20", params: nil) { (response : Friends) in
            self.friendList = response.results!
                self.updateUI()
        }
        
    }
}
