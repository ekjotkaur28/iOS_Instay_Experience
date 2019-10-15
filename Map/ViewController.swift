//
//  ViewController.swift
//  Map
//
//  Created by oyo on 12/07/18.
//  Copyright © 2018 oyo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate , UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet weak var ServiceCollection: UICollectionView!
   
    @IBOutlet weak var placesCollection: UICollectionView!
    
    @IBOutlet weak var servicesAvailableView: UIView!
    
    var services = ["ñ","","u","c","","","ʼ"]
    
    
    var imgArray = [UIImage(named: "AmbienceMall"),UIImage(named: "AppuGhar"), UIImage(named: "FunAndFoods"),UIImage(named: "KingdomOfDreams"), UIImage(named: "LeisureValleyPark")]
    var nameArray  = ["Ambience Mall","Appu Ghar ", "Fun And Foods", "Kingdom Of Dreams " , "Leisure Valley Park "]
    var dist = ["25 min", "18 min", "26 min", "19 min", "19 min"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnVal: Int = 0
        if collectionView == placesCollection{
        returnVal = imgArray.count
        }
        else if collectionView == ServiceCollection{
            
         returnVal =     services.count
        }
        return returnVal
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == placesCollection{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.img.image = imgArray[indexPath.row]
        cell.lbl.text = dist[indexPath.row]
        cell.car.image = UIImage(named: "car")
        cell.placeName.text = nameArray[indexPath.row]
        
        cell.img.layer.cornerRadius = 10
        return cell
        }
       var ce : ServicesCollectionViewCell
        
            ce = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! ServicesCollectionViewCell
            ce.label.text = services[indexPath.row]
        ce.label.textColor = UIColor.gray
        //ce.label.tintColor = UIColor.red
//            ce.servicePicture.layer.borderWidth = 1
//        ce.servicePicture.layer.borderColor = UIColor.red.cgColor
//        ce.servicePicture.layer.cornerRadius = 10
        
        
        return ce
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = nameArray[indexPath.row]
        let newString = name.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
         //www.google.com#q=elvis+is+alive =\(lat!)
        
        if let url = URL(string: "https://www.google.com/search?q=\(newString)") {
            print("hh")
            UIApplication.shared.open(url, options: [:])
        }
    
    }
    
    var out=GetWeather();
    
    @IBOutlet weak var placesView: UIView!
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var disappearView: UIView!
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
   // @IBOutlet weak var info1: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherConditions: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var dropPic: UIImageView!
    @IBOutlet weak var buttonBooking: UIButton!
    @IBOutlet weak var displayStack: UIStackView!
    let manager = CLLocationManager()
    var lat :Double!
    var long : Double!
    
    @IBAction func bookingDetailsButton(_ sender: Any) {
        animate(toggle: self.disappearView.isHidden)
    }
    
    @IBAction func Share(_ sender: Any) {
        let acti = UIActivityViewController(activityItems: ["Latitude: \( lat), Longitude: \(long)"], applicationActivities: nil)
        present(acti, animated: true, completion: nil)

    }
    
    func animate(toggle: Bool) {
        
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.disappearView.isHidden = !toggle
                self.disappearView.alpha = 1
                self.dropPic.image = (UIImage(named: "dropUp"))
                self.view.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.disappearView.isHidden = !toggle
                //disappearView.heightAnchor. = 0
                self.view.layoutIfNeeded()
                self.disappearView.alpha = 0
                self.dropPic.image   = (UIImage(named: "dropDown"))
            }
        }
    }
    
    
    func generateWelcomeMessage()-> String {
        let date = Date()
        let cal = Calendar.current
        let hour = cal.component(.hour, from: date)
        if(hour > 5 && hour < 12){
        return "Good Morning,"
        }
        else if( hour >= 12 && hour < 18){
            return "Hope you are having a great day,"
        }
         else if hour >= 18 && hour < 20
        {
            return "Congratulation! You made through the day,"
        }
        return "Good Evening,"
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let loc = (locations[0]);
        let current_loc2D = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        let annotation =  MKPointAnnotation()
        print(loc.coordinate.latitude)
        print(loc.coordinate.longitude)
       lat = loc.coordinate.latitude
        long = loc.coordinate.longitude
        annotation.coordinate = current_loc2D
        annotation.title = "IBIS Hotel"
        Map.addAnnotation(annotation)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(loc.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        Map.setRegion(coordinateRegion, animated: true)
    
        
    }
       
    


    
    @objc func back(sender: UIBarButtonItem) {
        print("HEY")
    }
   
    
    @objc func tap( recogniser : UITapGestureRecognizer){
        
        let url = "http://maps.apple.com/maps?ll=\(lat!),\(long!)"
        UIApplication.shared.openURL(URL(string:url)!)
    }
    override func viewDidLoad() {
         super.viewDidLoad()
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(recogniser:)))
        gestureRecogniser.numberOfTapsRequired = 1
        Map.isUserInteractionEnabled = true
        Map.isZoomEnabled = false
        Map.isScrollEnabled = false
        Map.addGestureRecognizer(gestureRecogniser)
        
       
        
        disappearView.isHidden = true
        let msg = generateWelcomeMessage()
        let name = "Rajesh"
        print(msg)
        placesView.layer.borderColor = UIColor(red: 225, green: 225, blue: 226, alpha: 1).cgColor
        placesView.layer.borderWidth = 1
        mapContainer.layer.borderColor = UIColor(red: 225, green: 225, blue: 226, alpha: 1).cgColor
        mapContainer.layer.borderWidth = 1
        servicesAvailableView.layer.borderColor = UIColor(red: 225, green: 225, blue: 226, alpha: 1).cgColor
        servicesAvailableView.layer.borderWidth = 1
        
        placesView.layer.cornerRadius = 4
        placesView.backgroundColor = UIColor.white
        placesView.layer.shadowColor = UIColor.black.cgColor
        placesView.layer.masksToBounds = false
        placesView.layer.shadowOffset = CGSize(width: 0, height: 2)
        placesView.layer.shadowOpacity = 0.2
        placesView.layer.shadowRadius = 4
        
        
        
        
        servicesAvailableView.layer.cornerRadius = 4
        servicesAvailableView.backgroundColor = UIColor.white
        servicesAvailableView.layer.shadowColor = UIColor.black.cgColor
        servicesAvailableView.layer.masksToBounds = false
        servicesAvailableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        servicesAvailableView.layer.shadowOpacity = 0.2
        servicesAvailableView.layer.shadowRadius = 4
        welcomeLabel.text = "\(msg) \(name)"
        
        mapContainer.layer.cornerRadius = 4
        mapContainer.backgroundColor = UIColor.white
        mapContainer.layer.shadowColor = UIColor.black.cgColor
        mapContainer.layer.masksToBounds = false
        Map.layer.cornerRadius = 4
        mapContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        mapContainer.layer.shadowRadius = 4
        mapContainer.layer.shadowOpacity = 0.2
        
        
        disappearView.layer.borderColor = UIColor(red: 225, green: 225, blue: 226, alpha: 1).cgColor
        disappearView.layer.borderWidth = 1
        disappearView.backgroundColor = UIColor.white
        disappearView.layer.shadowRadius = 1
        disappearView.layer.masksToBounds = false
        disappearView.layer.shadowColor = UIColor.black.cgColor
        disappearView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mapContainer.layer.shadowRadius = 4
        disappearView.layer.shadowOpacity = 0.2
        
        
        
        
       
        self.manager.delegate=self
        self.manager.desiredAccuracy=kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        Map.delegate = self
        
        
        var temp : Double!
        var desc : String!
        var coun : String!
        var ci :String!
        self.manager.startMonitoringSignificantLocationChanges()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways, .authorizedWhenInUse :
                print("Authorised")
                if let lat = self.manager.location?.coordinate.latitude,
                    let long = self.manager.location?.coordinate.longitude{
                    let  location = CLLocation(latitude: lat, longitude: long)
                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                        if error != nil {
                            return
                        }
                        else if let country = placemarks?.first?.country,
                            let city = placemarks?.first?.locality{
                            coun=country
                            ci=city
                            print("heyyy",country, coun!)
                            print(city, ci!);
                            self.out.getWeather(city: city, completion: { (success, response1, response2, response3, error) in
                                if  success {
                                    print(response1!,response2!,response3!)
                                    temp = response1! as! Double
                                    desc = "\(response2!)"
                                    temp = (temp - 273) ;
                                    temp = Double(round(1000*temp)/1000)
                                    
                                    self.weatherDescription.text = "\(desc!) \(temp!)℃"
                                    self.weatherIcon.image = UIImage(named: response3 as! String)
//                                    self.weatherView.Temp.text = "\(temp!)"
//                                    self.weatherView.Desc.text = desc!
//                                    self.weatherView.CityState.text = " \(ci!), \(coun!)"
                                } else if let error = error {
                                    print(error)
                                }
                            })
                            
                            
                            
                        }
                        
                        
                        
                    })
                }
                break
            case .notDetermined,.restricted, .denied :
                print("ERRORoooo")
                break
                
            }
            
        }
        
        
        
        print(temp)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

