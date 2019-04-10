//
//  StationInformationViewController.swift
//  transitApp
//
//  Created by William Du on 2018/6/8.
//  Copyright © 2018年 William Du. All rights reserved.
//

import UIKit
import MapKit

class StationInformationViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var stationInfoMapView: MKMapView!
    
    @IBOutlet weak var stationInfoLabel: UILabel!
    
    @IBOutlet weak var transportationInfoLabel: UILabel!
    var stationLatitude = CLLocationDegrees()
    var stationLongitude = CLLocationDegrees()
    var currentStation = ""
    var currentAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationInfoMapView.delegate = self
        self.navigationItem.title = NSLocalizedString(currentStation, comment: "") + NSLocalizedString(" Station", comment: "")
        self.tabBarItem.title = NSLocalizedString("Settings", comment: "")
        
        let centerCoordinate = CLLocationCoordinate2DMake(stationLatitude, stationLongitude)
        let region = MKCoordinateRegion.init(center: centerCoordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        stationInfoMapView.setRegion(region, animated: true)
        
        currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: stationLatitude, longitude: stationLongitude)
        currentAnnotation.title = NSLocalizedString(currentStation, comment: "")
        stationInfoMapView.addAnnotation(currentAnnotation)
        transportationInfoLabel.text = NSLocalizedString(getTransportationInformation(station: currentStation), comment: "")
        stationInfoLabel.text = NSLocalizedString(getStationInformation(station: currentStation), comment: "")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        if phoneNumber(forStation: currentStation) == "NULL"{
            let alertController = UIAlertController(title: NSLocalizedString("Sorry!", comment: "抱歉"), message: NSLocalizedString("Currently we don't have the phone number for ", comment: "") + NSLocalizedString(currentStation, comment:"") + NSLocalizedString(" Station. We will update frequently to update the information", comment: ""), preferredStyle: .alert)
            let alertAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            guard let phoneNumber = URL(string: phoneNumber(forStation: currentStation)) else { return }
            UIApplication.shared.open(phoneNumber, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func directionButtonAction(_ sender: UIButton) {
        launchInMaps(latitude: stationLatitude, longitude: stationLongitude)
    }
    
    func launchInMaps(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = NSLocalizedString(currentStation, comment: "")
        mapItem.openInMaps(launchOptions: options)
    }
    
    func phoneNumber(forStation:String) -> String{
        var returnString = ""
        switch forStation {
        case "Huangtudian":
            returnString = "tel://+861051869412"
        case "Nankou":
            returnString = "tel://+861051869292"
        case "Yanqing":
            returnString = "tel://+861051869221"
        default:
            returnString = "NULL"
        }
        return returnString
    }
    
    func getStationInformation(station:String) -> String{
        var returnValue = ""
        switch station {
        case "Huangtudian":
            returnValue = "Huangtudian station is the nearest station to the central area of Beijing. Visitors to Yanqing or Badaling Great Wall should ride the train from here."
        case "Nankou":
            returnValue = "Nankou station is located in Changping District. It is located near Ming Dynasty Tombs Scenic Area."
        case "Badaling":
            returnValue = "Badaling station is the cloeset station to Badaling Great Wall. Visitors can get off here and take the free shuttle to the Great Wall."
        case "Yanqing":
            returnValue = "Yanqing station has multiple buses connect to Yanqing District Center in a few minutes. Buses also head to several scenic areas from this station."
        case "Kangzhuang":
            returnValue = "Kangzhuang station is located at the town of Kangzhuang, which is close to the city border of Beijing."
        case "Shacheng":
            returnValue = "Shacheng station is located in Huailai city in Hebei Province. The station is close to Guanting Reservoir."
        default:
            break
        }
        return returnValue
    }
    
    func getTransportationInformation(station:String) -> String{
        var returnValue = ""
        switch station {
        case "Huangtudian":
            returnValue = "Subway: Line 8 and Line 13\nBus Routes:Rapid 19/Special Route 42/371/462/478/551/558/606/607/681"
        case "Nankou":
            returnValue = "Bus Routes:357/655/870/883/887/890 Commuter Route/949/Chang 11/Chang 12/Chang 20/Chang 33/Chang 69/Chang 70/Rapid 66"
        case "Badaling":
            returnValue = "Badaling Great Wall Free Shuttle"
        case "Yanqing":
            returnValue = "Bus Routes:Y1/Y2/Y3/Y5/Y8/Y10/Y15/Y20/Y21/Y35/Y40/Y42/Y44/Y46"
        case "Kangzhuang":
            returnValue = "Bus Routes:880/Y21/Y44/Y46"
        case "Shacheng":
            returnValue = "None"
        default:
            break
        }
        return returnValue
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
