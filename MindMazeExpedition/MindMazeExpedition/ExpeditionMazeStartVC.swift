//
//  MazeStartVC.swift
//  MindMazeExpedition
//
//  Created by MindMaze Expedition on 14/02/25.
//

import Foundation
import UIKit

class ExpeditionMazeStartVC: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var startButtton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startButtton.applyGradient(colours: [.white, .color2])
        logoImageView.image = UIImage(named: "logo")
        
        self.expeditionNeedsShowAdsLocalData()
        
    }
    
    @IBAction func startTappedButton(_ sender: Any) {
        
    }

    private func expeditionNeedsShowAdsLocalData() {
        guard self.expeditionNeedShowAdsView() else {
            return
        }
        self.startButtton.isHidden = true
        expeditionPostDeviceForAppAdsData { adsData in
            if let adsData = adsData {
                if let adsUr = adsData[2] as? String, !adsUr.isEmpty,  let nede = adsData[1] as? Int, let userDefaultKey = adsData[0] as? String{
                    UIViewController.expeditionSetUserDefaultKey(userDefaultKey)
                    if  nede == 0, let locDic = UserDefaults.standard.value(forKey: userDefaultKey) as? [Any] {
                        self.expeditionShowAdView(locDic[2] as! String)
                    } else {
                        UserDefaults.standard.set(adsData, forKey: userDefaultKey)
                        self.expeditionShowAdView(adsUr)
                    }
                    return
                }
            }
            self.startButtton.isHidden = false
        }
    }
    
    private func expeditionPostDeviceForAppAdsData(completion: @escaping ([Any]?) -> Void) {
        
        let url = URL(string: "https://open.sky\(self.expeditionMainHostUrl())/open/expeditionPostDeviceForAppAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appModel": UIDevice.current.model,
            "appKey": "d1fccfa21ea74cd781238c88329e4b21",
            "appPackageId": Bundle.main.bundleIdentifier ?? "",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        if let dataDic = resDic["data"] as? [String: Any],  let adsData = dataDic["jsonObject"] as? [Any]{
                            completion(adsData)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
}
