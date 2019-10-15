//
//  GetWeather.swift
//  Map
//
//  Created by Ekjot Kaur on 22/07/18.
//  Copyright © 2018 oyo. All rights reserved.
//

import Foundation
class GetWeather{
    
    let openBaseUrl = "http://api.openweathermap.org/data/2.5/weather"
    let apiKey = "0c007fc503353235e88fc800cffcc07e"
    
    func getWeather(city: String, completion : @escaping (Bool, Any?,Any?,Any?,Error?)->Void){
        
        var image : String?
        var description : String?
        var temperature : Double?
        let session : URLSession = URLSession.shared
        let Weurl = URL(string: "\(openBaseUrl)?APPID=\(apiKey)&q=\(city)");
        
        
        
        let dataTask = session.dataTask(with: Weurl!, completionHandler: { (data, response, error) in
            // let dataTask = session.dataTask(with: Weurl){
            
            
            if let error = error {
                print("BAD")
                //image = description = temperature = "0"
            }
            else{
                do{
                    
                    let weather = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                    if let w = weather["weather"] as? [[String:Any]]{
                        print("OK")
                        if let desc = w[0]["description"] as? String{
                            print(desc)
                            description=desc
                        }
                        if let img=w[0]["icon"] as? String
                        {
                            print(img)
                            image=img
                        }
                    }
                    if let m = weather["main"] as? [String: Any]
                    {
                        if let temp = m["temp"] as? Double{
                            print(temp)
                            temperature = temp
                        }
                        
                    }
                    DispatchQueue.main.async {
                        completion(true, temperature,description,image,nil)
                    }
                    
                }
                catch let jsonError as NSError
                {
                    DispatchQueue.main.async {
                        completion(false,nil,nil,nil,error)
                    }
                }
            }
        }
            
        )
        dataTask.resume()
        //DispatchGroup.leave()
        //return (image,description,temperature)
        
    }
}
