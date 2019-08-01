//
//  mapViewController.swift
//  transitApp
//
//  Created by William Du on 2018/3/12.
//  Copyright © 2018年 William Du. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol mapViewControllerDelegate:class {
    func changeTitle(_ currentTitle:String)
    func passOffStationName(_ mapView:mapViewController)
}

class mapViewController: UIViewController, MKMapViewDelegate, CustomCalloutViewDelegate {
    // CLLocationManagerDelegate
    
    func informationButtonTapped(_ calloutView: CustomCalloutView) {
        currentStationSelectedForInformation = calloutView.stationName
        self.performSegue(withIdentifier: "showStationDetail", sender: nil)
    }
    
//    let locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    var centerCoordinate = CLLocationCoordinate2D()
    var startStation = "Huangtudian"
    var destinationStation = "Yanqing"
    var currentClicked = ""
    var currentTitle = "Destination"
    var selectedFromMap = false

    var currentStationSelectedForInformation = ""
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func currentButtonAction(_ sender: UIButton) {
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
        let coordinates = [(40.071349, 116.364796),(40.071732, 116.311377),(40.078852, 116.292691),(40.141147, 116.255784)].map(CLLocationCoordinate2DMake)
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }()
    
    
    let huangtudianStationAnnotation = MKPointAnnotation()
    let nankouStationAnnotation = MKPointAnnotation()
    let badalingStationAnnotation = MKPointAnnotation()
    let yanqingStationAnnotation = MKPointAnnotation()
    let kangzhuangStationAnnotation = MKPointAnnotation()
    let shachengStationAnnotation = MKPointAnnotation()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = NSLocalizedString("System Map", comment: "xianlutu")
        self.navigationItem.title = NSLocalizedString("BSR System Map", comment: "xianlutu")
        
        
        mapView.delegate = self
        
        centerCoordinate = CLLocationCoordinate2D(latitude: 40.225323, longitude: 116.147442)
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: 40.225323, longitude: 116.147442), latitudinalMeters: 150000, longitudinalMeters: 150000)
        mapView.setRegion(region, animated: true)
        
        
        let s2StationAnnotationArray = [huangtudianStationAnnotation,nankouStationAnnotation,badalingStationAnnotation,yanqingStationAnnotation,kangzhuangStationAnnotation,shachengStationAnnotation]
        
        for index in 0..<s2StationAnnotationArray.count {
            s2StationAnnotationArray[index].subtitle = s2StationArray[index]
            s2StationAnnotationArray[index].coordinate = CLLocationCoordinate2D(latitude: s2StationCoordinates[index].0, longitude: s2StationCoordinates[index].1)
            mapView.addAnnotation(s2StationAnnotationArray[index])
        }
        
        mapView.addOverlay(s2line)
        mapView.addOverlay(s2line_trunk)
        
        // Check Version
        let userDefaults = UserDefaults.standard
        
        let currentVersion = userDefaults.string(forKey: "version") ?? "NOT_LOADED"
        if currentVersion != "20190801" {
            ScheduleInit.trainInit()
            userDefaults.set("20190801", forKey: "version")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        let transfer_pinImage = #imageLiteral(resourceName: "s2_station")
        let s2_pinImage = #imageLiteral(resourceName: "s2_station")
        
        
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
        print("current subtitle:\(subtitle)")
        
        customView.stationName = subtitle
        customView.stationLabel.text = NSLocalizedString(subtitle, comment: "Subtitle")
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
            customView.first_line_label.text = NSLocalizedString("Line S2", comment: "XIANLUMING")
//            customView.second_line_label.text = "Line S5"
            customView.first_line_label.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.1411764706, blue: 0.9843137255, alpha: 1)
//            customView.second_line_label.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            customView.second_line_label.isHidden = true
            customView.third_line_label.isHidden = true
        } else if s2StationArray.contains(subtitle) {
            customView.first_line_label.text = NSLocalizedString("Line S2", comment: "XIANLUMING")
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
        calloutView.directionButtonOutlet.setTitle(NSLocalizedString(currentTitle, comment: ""), for: .normal)
    }

    func directionButtonTapped(_ calloutView: CustomCalloutView) {
        let s2StationAnnotationArray = [huangtudianStationAnnotation,nankouStationAnnotation,badalingStationAnnotation,yanqingStationAnnotation,kangzhuangStationAnnotation,shachengStationAnnotation]
        let stationSelected = calloutView.stationName
        if selectedFromMap == false {
            if stationSelected != startStation{
                destinationStation = stationSelected
                changeButtonSequence(station: stationSelected, type: "destination")
                currentTitle = "From"
                selectedFromMap = true
            }else{
                checkDuplicateStation()
            }
        } else {
            if stationSelected != destinationStation{
                startStation = stationSelected
                changeButtonSequence(station: stationSelected, type: "origin")
                currentTitle = "Destination"
                selectedFromMap = false
                self.performSegue(withIdentifier: "showSchedule", sender: nil)
            }else{
                checkDuplicateStation()
            }
            
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
    
    func checkDuplicateStation(){
        let alertController = UIAlertController(title: NSLocalizedString("Opps!", comment: ""), message: NSLocalizedString("You've selected duplicated station. Want to start over?", comment: ""), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSchedule"{
            let destVC = segue.destination as! ViewController
            destVC.startPlace = startStation
            destVC.destinationPlace = destinationStation
            destVC.trainDirection = determineTrainDirection(from: startStation, to: destinationStation)
            changeButtonSequence(station: "Huangtudian", type: "origin")
            changeButtonSequence(station: "Yanqing", type: "destination")
            self.startStation = "Huangtudian"
            self.destinationStation = "Yanqing"
            self.currentTitle = "Destination"
            self.selectedFromMap = false
        }
        
        if segue.identifier == "showStationDetail"{
            let destVC = segue.destination as! StationInformationViewController
            destVC.currentStation = self.currentStationSelectedForInformation
            for index in 0...self.s2StationArray.count{
                if s2StationArray[index] == currentStationSelectedForInformation{
                    destVC.stationLatitude = s2StationCoordinates[index].0
                    destVC.stationLongitude = s2StationCoordinates[index].1
                    break
                }
            }
            
        }
     }
    
    // SELECTION STACK
    
    
    
    @IBOutlet weak var originSelectionStackView: UIStackView!
    @IBAction func handleOriginSelection(_ sender: UIButton) {
        if originStationButtons.first?.isHidden == false{
            switch sender.tag{
            case 1:
                self.startStation = "Huangtudian"
            case 2:
                self.startStation = "Nankou"
            case 3:
                self.startStation = "Badaling"
            case 4:
                self.startStation = "Yanqing"
            case 5:
                self.startStation = "Kangzhuang"
            case 6:
                self.startStation = "Shacheng"
            default:
                break
            }
        }
        originStationButtons.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
            })
        }
    }
    
    @IBOutlet var originStationButtons: [UIButton]!
    
    @IBOutlet weak var originFirstButton: UIButton!
    
    func changeButtonSequence(station:String,type:String){
        if type == "origin"{
            switch station {
            case "Huangtudian":
                originFirstButton.setTitle(NSLocalizedString("Huangtudian", comment: ""), for: .normal)
                originFirstButton.tag = 1
                let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tags = [2,3,4,5,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.setTitle(stations[counter], for: .normal)
                    button.tag = tags[counter]
                    counter += 1
                }
            case "Nankou":
                originFirstButton.setTitle(NSLocalizedString("Nankou", comment: ""), for: .normal)
                originFirstButton.tag = 2
                let stations = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tags = [1,3,4,5,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.setTitle(stations[counter], for: .normal)
                    button.tag = tags[counter]
                    counter += 1
                }
            case "Badaling":
                originFirstButton.setTitle(NSLocalizedString("Badaling", comment: ""), for: .normal)
                originFirstButton.tag = 3
                let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tags = [2,1,4,5,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.setTitle(stations[counter], for: .normal)
                    button.tag = tags[counter]
                    counter += 1
                }
                
            case "Yanqing":
                originFirstButton.setTitle(NSLocalizedString("Yanqing", comment: ""), for: .normal)
                originFirstButton.tag = 4
                let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tags = [2,3,1,5,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.setTitle(stations[counter], for: .normal)
                    button.tag = tags[counter]
                    counter += 1
                }
            case "Kangzhuang":
                originFirstButton.setTitle(NSLocalizedString("Kangzhuang", comment: ""), for: .normal)
                originFirstButton.tag = 5
                let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tags = [2,3,4,1,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.setTitle(stations[counter], for: .normal)
                    button.tag = tags[counter]
                    counter += 1
                }
            case "Shacheng":
                originFirstButton.setTitle(NSLocalizedString("Shacheng", comment: ""), for: .normal)
                originFirstButton.tag = 6
                let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Huangtudian", comment: "")]
                let tags = [2,3,4,5,1]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.setTitle(stations[counter], for: .normal)
                    button.tag = tags[counter]
                    counter += 1
                }
            default:
                break
            }
        }else{
            if type == "destination"{
                switch station {
                case "Huangtudian":
                    destinationFirstButton.setTitle(NSLocalizedString("Huangtudian", comment: ""), for: .normal)
                    destinationFirstButton.tag = 1
                    let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                    let tags = [2,3,4,5,6]
                    var counter = 0
                    destinationButtons.forEach { (button) in
                        button.setTitle(stations[counter], for: .normal)
                        button.tag = tags[counter]
                        counter += 1
                    }
                case "Nankou":
                    destinationFirstButton.setTitle(NSLocalizedString("Nankou", comment: ""), for: .normal)
                    destinationFirstButton.tag = 2
                    let stations = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                    let tags = [1,3,4,5,6]
                    var counter = 0
                    destinationButtons.forEach { (button) in
                        button.setTitle(stations[counter], for: .normal)
                        button.tag = tags[counter]
                        counter += 1
                    }
                case "Badaling":
                    destinationFirstButton.setTitle(NSLocalizedString("Badaling", comment: ""), for: .normal)
                    destinationFirstButton.tag = 3
                    let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                    let tags = [2,1,4,5,6]
                    var counter = 0
                    destinationButtons.forEach { (button) in
                        button.setTitle(stations[counter], for: .normal)
                        button.tag = tags[counter]
                        counter += 1
                    }
                    
                case "Yanqing":
                    destinationFirstButton.setTitle(NSLocalizedString("Yanqing", comment: ""), for: .normal)
                    destinationFirstButton.tag = 4
                    let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                    let tags = [2,3,1,5,6]
                    var counter = 0
                    destinationButtons.forEach { (button) in
                        button.setTitle(stations[counter], for: .normal)
                        button.tag = tags[counter]
                        counter += 1
                    }
                case "Kangzhuang":
                    destinationFirstButton.setTitle(NSLocalizedString("Kangzhuang", comment: ""), for: .normal)
                    destinationFirstButton.tag = 5
                    let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                    let tags = [2,3,4,1,6]
                    var counter = 0
                    destinationButtons.forEach { (button) in
                        button.setTitle(stations[counter], for: .normal)
                        button.tag = tags[counter]
                        counter += 1
                    }
                case "Shacheng":
                    destinationFirstButton.setTitle(NSLocalizedString("Shacheng", comment: ""), for: .normal)
                    destinationFirstButton.tag = 6
                    let stations = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Huangtudian", comment: "")]
                    let tags = [2,3,4,5,1]
                    var counter = 0
                    destinationButtons.forEach { (button) in
                        button.setTitle(stations[counter], for: .normal)
                        button.tag = tags[counter]
                        counter += 1
                    }
                default:
                    break
                }
            }
        }
        
    }
    
    @IBAction func stationTapped(_ sender: UIButton) { //OriginStationTapped
        switch sender.tag {
        case 1:
            if self.destinationStation != "Huangtudian"{
                originFirstButton.tag = 1
                originFirstButton.setTitle(NSLocalizedString("Huangtudian", comment: ""), for: .normal)
                self.startStation = "Huangtudian"
                let stationStringExcept1 = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept1 = [2,3,4,5,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                originStationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept1[counter], for: .normal)
                    button.tag = tagExcept1[counter]
                    counter += 1
                }
            }else{
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 2:
            if self.destinationStation != "Nankou"{
                originFirstButton.tag = 2
                originFirstButton.setTitle(NSLocalizedString("Nankou", comment: ""), for: .normal)
                self.startStation = "Nankou"
                let stationStringExcept2 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept2 = [1,3,4,5,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                originStationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept2[counter], for: .normal)
                    button.tag = tagExcept2[counter]
                    counter += 1
                }
            }else{
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 3:
            if self.destinationStation != "Badaling"{
                originFirstButton.tag = 3
                originFirstButton.setTitle(NSLocalizedString("Badaling", comment: ""), for: .normal)
                self.startStation = "Badaling"
                let stationStringExcept3 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept3 = [1,2,4,5,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                originStationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept3[counter], for: .normal)
                    button.tag = tagExcept3[counter]
                    counter += 1
                }
            }else{
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 4:
            if self.destinationStation != "Yanqing"{
                originFirstButton.tag = 4
                originFirstButton.setTitle(NSLocalizedString("Yanqing", comment: ""), for: .normal)
                self.startStation = "Yanqing"
                let stationStringExcept4 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept4 = [1,2,3,5,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                originStationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept4[counter], for: .normal)
                    button.tag = tagExcept4[counter]
                    counter += 1
                }
            }else{
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 5:
            if self.destinationStation != "Kangzhuang"{
                originFirstButton.tag = 5
                originFirstButton.setTitle(NSLocalizedString("Kangzhuang", comment: ""), for: .normal)
                self.startStation = "Kangzhuang"
                let stationStringExcept5 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept5 = [1,2,3,4,6]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                originStationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept5[counter], for: .normal)
                    button.tag = tagExcept5[counter]
                    counter += 1
                }
            }else{
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 6:
            if self.destinationStation != "Shacheng"{
                originFirstButton.tag = 6
                originFirstButton.setTitle(NSLocalizedString("Shacheng", comment: ""), for: .normal)
                self.startStation = "Shacheng"
                let stationStringExcept6 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: "")]
                let tagExcept6 = [1,2,3,4,5]
                var counter = 0
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                originStationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept6[counter], for: .normal)
                    button.tag = tagExcept6[counter]
                    counter += 1
                }
            }else{
                originStationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        default:
            break
        }
    }
    
    
    @IBAction func handleDestinationSelection(_ sender: UIButton) {
        if destinationButtons.first?.isHidden == false{
            switch sender.tag{
            case 1:
                self.destinationStation = "Huangtudian"
            case 2:
                self.destinationStation = "Nankou"
            case 3:
                self.destinationStation = "Badaling"
            case 4:
                self.destinationStation = "Yanqing"
            case 5:
                self.destinationStation = "Kangzhuang"
            case 6:
                self.destinationStation = "Shacheng"
            default:
                break
            }
        }
        destinationButtons.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
            })
        }
    }
    
    @IBOutlet weak var destinationFirstButton: UIButton!
    
    @IBAction func destinationStationTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if self.startStation != "Huangtudian"{
                destinationFirstButton.tag = 1
                destinationFirstButton.setTitle(NSLocalizedString("Huangtudian", comment: ""), for: .normal)
                self.destinationStation = "Huangtudian"
                let stationStringExcept1 = [NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept1 = [2,3,4,5,6]
                var counter = 0
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                destinationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept1[counter], for: .normal)
                    button.tag = tagExcept1[counter]
                    counter += 1
                }
            }else{
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 2:
            if self.startStation != "Nankou"{
                destinationFirstButton.tag = 2
                destinationFirstButton.setTitle(NSLocalizedString("Nankou", comment: ""), for: .normal)
                self.destinationStation = "Nankou"
                let stationStringExcept2 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept2 = [1,3,4,5,6]
                var counter = 0
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                destinationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept2[counter], for: .normal)
                    button.tag = tagExcept2[counter]
                    counter += 1
                }
            }else{
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 3:
            if self.startStation != "Badaling"{
                destinationFirstButton.tag = 3
                destinationFirstButton.setTitle(NSLocalizedString("Badaling", comment: ""), for: .normal)
                self.destinationStation = "Badaling"
                let stationStringExcept3 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept3 = [1,2,4,5,6]
                var counter = 0
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                destinationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept3[counter], for: .normal)
                    button.tag = tagExcept3[counter]
                    counter += 1
                }
            }else{
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 4:
            if self.startStation != "Yanqing"{
                destinationFirstButton.tag = 4
                destinationFirstButton.setTitle(NSLocalizedString("Yanqing", comment: ""), for: .normal)
                self.destinationStation = "Yanqing"
                let stationStringExcept4 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Kangzhuang", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept4 = [1,2,3,5,6]
                var counter = 0
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                destinationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept4[counter], for: .normal)
                    button.tag = tagExcept4[counter]
                    counter += 1
                }
            }else{
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 5:
            if self.startStation != "Kangzhuang"{
                destinationFirstButton.tag = 5
                destinationFirstButton.setTitle(NSLocalizedString("Kangzhuang", comment: ""), for: .normal)
                self.destinationStation = "Kangzhuang"
                let stationStringExcept5 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Shacheng", comment: "")]
                let tagExcept5 = [1,2,3,4,6]
                var counter = 0
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                destinationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept5[counter], for: .normal)
                    button.tag = tagExcept5[counter]
                    counter += 1
                }
            }else{
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        case 6:
            if self.startStation != "Shacheng"{
                destinationFirstButton.tag = 6
                destinationFirstButton.setTitle(NSLocalizedString("Shacheng", comment: ""), for: .normal)
                self.destinationStation = "Shacheng"
                let stationStringExcept6 = [NSLocalizedString("Huangtudian", comment: ""),NSLocalizedString("Nankou", comment: ""),NSLocalizedString("Badaling", comment: ""),NSLocalizedString("Yanqing", comment: ""),NSLocalizedString("Kangzhuang", comment: "")]
                let tagExcept6 = [1,2,3,4,5]
                var counter = 0
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                destinationButtons.forEach { (button) in
                    button.setTitle(stationStringExcept6[counter], for: .normal)
                    button.tag = tagExcept6[counter]
                    counter += 1
                }
            }else{
                destinationButtons.forEach { (button) in
                    button.isHidden = true
                }
                checkDuplicateStation()
            }
            
        default:
            break
        }
    }
    
    
    @IBAction func showButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showSchedule", sender: nil)
    }
    
    @IBOutlet var destinationButtons: [UIButton]!
}
