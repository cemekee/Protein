//
//  DetailVC.swift
//  ProteinCase
//
//  Created by Cem Eke on 8.11.2021.
//

import Foundation
import UIKit
import Kingfisher
import MapKit

class DetailVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var friendDetail: Friend?
    
    override func viewDidLoad() {
        setupUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
   
}

extension DetailVC {
    func setupUI(){
        let url = URL(string: friendDetail?.picture?.large ?? "")
        imageView.kf.setImage(with: url)
        lblName.text = friendDetail?.name?.first
        lblMail.text = friendDetail?.email
        lblPhone.text = friendDetail?.phone
        lblGender.text = friendDetail?.gender
        
        let latitude = Double(friendDetail?.location?.coordinates?.latitude ?? "") ?? 0.0
        let longitude = Double(friendDetail?.location?.coordinates?.longitude ?? "") ?? 0.0
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)
      
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude:longitude)
        annotation.coordinate = centerCoordinate
        annotation.title = "Home"
        mapView.addAnnotation(annotation)
    }
}
