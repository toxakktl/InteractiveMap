//
//  ViewController.swift
//  InteractiveMap
//
//  Created by Tokhtar Yelemessov on 1/31/18.
//  Copyright © 2018 Tokhtar Yelemessov. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    var zoom:Float = 6.2
    let zoomSize:Float = 0.5
    
    struct Location: Codable {
        let longitude:Double
        let latitude:Double
    }

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let camera = GMSCameraPosition.camera(withLatitude: 51.5077, longitude: 64.0479, zoom: 6.2)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
//        showMarker(position: camera.target)
        polygon()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //display a marker on the map
    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Kostanay Region"
        marker.snippet = "Qosta"
        marker.icon = imageWithImage(image: UIImage(named: "icon_brown")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
        
        marker.map = mapView
    }
    
    //Method to resize the marker on the map
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x:0, y:0, width: newSize.width,height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //draw a polygon
    func polygon(){
        let path = Bundle.main.path(forResource: "kostanay-region", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        var coordinates =  [Location]()
        do {
            let data = try Data(contentsOf: url)
            coordinates = try JSONDecoder().decode([Location].self, from: data)
        }catch {
            print(error)
        }
        // Create a rectangular path
        let rect = GMSMutablePath()
        for location in coordinates {
            rect.add(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.1);
        polygon.strokeColor = .gray
        polygon.strokeWidth = 2
        polygon.map = mapView
    }
    @IBAction func zoomOutPressed(_ sender: RoundButton) {
        zoom = zoom - zoomSize
        mapView.animate(toZoom: zoom)
    }
    
    @IBAction func zoomInPressed(_ sender: RoundButton) {
        zoom = zoom + zoomSize
        mapView.animate(toZoom: zoom)
    }
}
