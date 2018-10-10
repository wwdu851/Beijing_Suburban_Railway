//
//  mapViewController.swift
//  transitApp
//
//  Created by William Du on 2018/3/12.
//  Copyright © 2018年 William Du. All rights reserved.
//

import UIKit
import MapKit

protocol mapViewControllerDelegate:class {
    func changeTitle(_ currentTitle:String)
    func passOffStationName(_ mapView:mapViewController)
}

class mapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, CustomCalloutViewDelegate {
    func informationButtonTapped(_ calloutView: CustomCalloutView) {
        print("Information Tapped")
        
    }
    
    let locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    var centerCoordinate = CLLocationCoordinate2D()
    var startStation = ""
    var destinationStation = ""
    var currentClicked = ""
    var currentTitle = "Destination"
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func currentButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func goAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showSchedule", sender: nil)
        startStation = ""
        destinationStation = ""
        currentTitle = "Destination"
    }
    
    
    weak var delegate:mapViewControllerDelegate?
    
    //Station and coordinate configuration
    let s2StationArray = ["Huangtudian","Nankou","Badaling","Yanqing","Kangzhuang","Shacheng"]
    let s2StationRouteArray = ["S2","S2","S2","S2","S2","S2"]
    let s2StationCoordinates = [(40.070349,116.363796),(40.239901,116.129669),(40.360377, 116.001454),(40.436184, 115.984262),(40.379420, 115.898183),(40.396959,115.515637)]
    
    let transferStation = ["Huangtudian"]
    
    // Station Data Configuration

    
    // Railway System Map Overlay Configuration
    
    lazy var s2line: MKPolyline = {
        let coordinates = [
            (40.070349, 116.363796),(40.070732, 116.310377),(40.077852, 116.291691),(40.140147, 116.254784),(40.210151, 116.171743),(40.222995, 116.136896),(40.235902, 116.120073),(40.238922, 116.123281),(40.239901, 116.129669),(40.255669, 116.127359),(40.262252, 116.114184),(40.27057, 116.10809),(40.286547, 116.079423),(40.294338, 116.080367),(40.295647, 116.072127),(40.3251, 116.041743),(40.327668, 116.042709),(40.337188, 116.03713),(40.337777, 116.028118),(40.348375, 116.022625),(40.353902, 116.029521),(40.350108, 116.019564),(40.360377, 116.001454),(40.363451, 115.995188),(40.363582, 115.995188),(40.362535, 115.991068),(40.364366, 115.966178),(40.377575, 115.92764),(40.382741, 115.92249),(40.390847, 115.924292),(40.404836, 115.933648),(40.417775, 115.946351),(40.429406, 115.9618),(40.436184, 115.984262)
            ].map(CLLocationCoordinate2DMake)
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }()
    
    lazy var s2line_trunk: MKPolyline = {
        let coordinates = [(40.377575, 115.92764),(40.380468, 115.913778),(40.379442, 115.897948),(40.377284, 115.861170),(40.365121, 115.841858),(40.337387, 115.777485),(40.336373, 115.742209),(40.337387, 115.737231),(40.353872, 115.706675),(40.354690, 115.701997),(40.352446, 115.688516),(40.353754, 115.674955),(40.353411, 115.652140),(40.354016, 115.646818),(40.363434, 115.598238),(40.396959,115.515637)].map(CLLocationCoordinate2DMake)
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }()
    
    lazy var s5line: MKPolyline = {
        let coordinate = [(40.071349, 116.364796),(40.071732, 116.311377),(40.078852, 116.292691),(40.141147, 116.255784)].map(CLLocationCoordinate2DMake)
        return MKPolyline(coordinates: coordinate, count: coordinate.count)
    }()
    
    
    let huangtudianStationAnnotation = MKPointAnnotation()
    let nankouStationAnnotation = MKPointAnnotation()
    let badalingStationAnnotation = MKPointAnnotation()
    let yanqingStationAnnotation = MKPointAnnotation()
    let kangzhuangStationAnnotation = MKPointAnnotation()
    let shachengStationAnnotation = MKPointAnnotation()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        guard let newCoordinates = locationManager.location?.coordinate else {
            return
        }
        
        centerCoordinate = CLLocationCoordinate2D(latitude: 40.225323, longitude: 116.147442)
        let region = MKCoordinateRegion.init(center: centerCoordinate, latitudinalMeters: 150000, longitudinalMeters: 150000)
        mapView.setRegion(region, animated: true)
        
        coordinate = newCoordinates
        
        let s2StationAnnotationArray = [huangtudianStationAnnotation,nankouStationAnnotation,badalingStationAnnotation,yanqingStationAnnotation,kangzhuangStationAnnotation,shachengStationAnnotation]
        
        for index in 0..<s2StationAnnotationArray.count {
            s2StationAnnotationArray[index].subtitle = s2StationArray[index]
            s2StationAnnotationArray[index].coordinate = CLLocationCoordinate2D(latitude: s2StationCoordinates[index].0, longitude: s2StationCoordinates[index].1)
            mapView.addAnnotation(s2StationAnnotationArray[index])
        }
        
        mapView.addOverlay(s2line)
        mapView.addOverlay(s2line_trunk)
        
        // Core Data Test
//        ScheduleInit.trainInfoWithNumber(trainNumber: 203, from: "Huangtudian", to: "Badaling")
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        let transfer_pinImage = #imageLiteral(resourceName: "transfer")
        let s2_pinImage = #imageLiteral(resourceName: "s2_station")
        
        
        //resize image
/*
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContext(size)
        
        pinImage.draw(in: CGRect(origin: .zero, size: size))
        let resizedimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        */
        let s2_resizedImage = UIImage(cgImage: s2_pinImage.cgImage!, scale: s2_pinImage.size.width / 5, orientation: .up)
        let transfer_resizedImage = UIImage(cgImage: transfer_pinImage.cgImage!, scale: transfer_pinImage.size.width / 5, orientation: .up)
        pin.canShowCallout = true
        if annotation.subtitle == "Huangtudian"{
            pin.image = transfer_resizedImage
        }else{
            pin.image = s2_resizedImage
        }
        
        let customView = (Bundle.main.loadNibNamed("CustomAnnotationCalloutXib", owner: self, options: nil))?[0] as! CustomCalloutView
        
        let subtitle = annotation.subtitle!!
        
        customView.stationLabel.text = subtitle
        customView.currentClicked = annotation.subtitle!!
        
        customView.delegate = self
        customView.first_line_label.layer.masksToBounds = true
        customView.first_line_label.layer.cornerRadius = 5
        customView.second_line_label.layer.masksToBounds = true
        customView.second_line_label.layer.cornerRadius = 5
        customView.third_line_label.layer.masksToBounds = true
        customView.third_line_label.layer.cornerRadius = 5
        delegate = customView
        
        if transferStation.contains(subtitle) {
            customView.first_line_label.text = "Line S2"
//            customView.second_line_label.text = "Line S5"
            customView.first_line_label.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.1411764706, blue: 0.9843137255, alpha: 1)
//            customView.second_line_label.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            customView.second_line_label.isHidden = true
            customView.third_line_label.isHidden = true
        } else if s2StationArray.contains(subtitle) {
            customView.first_line_label.text = "Line S2"
            customView.first_line_label.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.1411764706, blue: 0.9843137255, alpha: 1)
            customView.second_line_label.isHidden = true
            customView.third_line_label.isHidden = true
        }
        

        pin.detailCalloutAccessoryView = customView
        return pin
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let line = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let lineRenderer = MKPolylineRenderer(polyline:line)
        if line == s5line {
            lineRenderer.strokeColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            lineRenderer.strokeColor = #colorLiteral(red: 0.0431372549, green: 0.1411764706, blue: 0.9843137255, alpha: 1)
        }
        lineRenderer.lineWidth = 2.0
        return lineRenderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let calloutView = view.detailCalloutAccessoryView as? CustomCalloutView else{
            return
        }
        if destinationStation == "" {
            calloutView.directionButtonOutlet.setTitle("Destination", for: .normal)
        } else {
            calloutView.directionButtonOutlet.setTitle("From", for: .normal)
        }
    }

    func directionButtonTapped(_ calloutView: CustomCalloutView) {
        let s2StationAnnotationArray = [huangtudianStationAnnotation,nankouStationAnnotation,badalingStationAnnotation,yanqingStationAnnotation,kangzhuangStationAnnotation,shachengStationAnnotation]
        let stationSelected = calloutView.stationLabel.text!
        if destinationStation == "" {
            destinationStation = stationSelected
            currentTitle = "From"
        } else {
            startStation = stationSelected
            
        }
        for annotation in s2StationAnnotationArray{
            self.mapView.deselectAnnotation(annotation, animated: true)
        }
        
    }
    
    func determineTrainDirection(from:String,to:String) -> String{
        var returnValue = "North"
        var fromIndex = 0
        var toIndex = 0
        let stationValueList = [("Huangtudian",1),("Nankou",2),("Badaling",3),("Yanqing",4),("Kangzhuang",5),("Shacheng",6)]
        for eachStation in stationValueList{
            if eachStation.0 == from{
                fromIndex = eachStation.1
            }
            if eachStation.0 == to{
                toIndex = eachStation.1
            }
        }
        
        if fromIndex > toIndex{
            returnValue = "South"
        }
        return returnValue
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSchedule"{
            let destVC = segue.destination as! ViewController
            destVC.startPlace = startStation
            destVC.destinationPlace = destinationStation
            destVC.trainDirection = determineTrainDirection(from: startStation, to: destinationStation)
        }
     }
    
    
    @IBOutlet weak var originSelectionStackView: UIStackView!
    @IBAction func handleOriginSelection(_ sender: UIButton) {
        originStationButtons.forEach { (button) in
            button.isHidden = !button.isHidden
            
        }
    }
    
    @IBOutlet var originStationButtons: [UIButton]!
    
    @IBAction func stationTapped(_ sender: UIButton) { //OriginStationTapped
    }
    
    
    @IBAction func handleDestinationSelection(_ sender: UIButton) {
        destinationButtons.forEach { (button) in
            button.isHidden = !button.isHidden
        }
    }
    
    
    @IBOutlet var destinationButtons: [UIButton]!
    
    
    
    
}
