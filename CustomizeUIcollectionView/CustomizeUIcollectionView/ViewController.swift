//
//  ViewController.swift
//  CustomizeUIcollectionView
//
//  Created by Cid Hsieh on 2017/5/12.
//  Copyright © 2017年 Cid Hsieh. All rights reserved.
//

import UIKit
import CoreMotion
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cellContent = ["顯示一個Alert View","顯示藍色，點擊後變成紅色，再次點擊又會是藍色","透過過core motion顯示使用者現在的步數，並且即時更新","開啟此App在IOS的設定頁面","打開google map或是web導航至Alpha camp","開啟信箱，並將標題填上測試信件"]
    
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (deviceManager, error) in
            let accelerationThrehold:Double = 1
            let userAcceleration:CMAcceleration = deviceManager!.userAcceleration
            
            if let myData = deviceManager {
                print(myData)
            }
            
            if (fabs(userAcceleration.x) > accelerationThrehold) || (fabs(userAcceleration.y) > accelerationThrehold) || (fabs(userAcceleration.z) > accelerationThrehold) {
                
                print("")
            }
        }
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //導航function，帶入經緯度，目的地名稱的參數
    func navigation(lat:Float, lon:Float, placeName:String){
        let latitude: CLLocationDegrees = CLLocationDegrees(lat)
        let longitude:CLLocationDegrees = CLLocationDegrees(lon)
        
        let regineDistance:CLLocationDistance = 1000.0
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let reginSpan = MKCoordinateRegionMakeWithDistance(coordinates, regineDistance, regineDistance)
        
        let option = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: reginSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: reginSpan.span)]
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: option)
    }


}
extension ViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellContent.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //產生Alert view
        if indexPath.row == 0 {
            let alertAction = UIAlertController(title: "alert", message: "", preferredStyle: .alert)
            alertAction.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alertAction, animated: true, completion: nil)
        //點選讓cell顏色變化
        } else if indexPath.row == 1 {
            print("000")
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            if cell.backgroundColor == UIColor.blue {
                cell.backgroundColor = UIColor.red
                print("123")
            } else {
                cell.backgroundColor = UIColor.blue
                print("456")
            }
        //加入core motion功能
        }else if indexPath.row == 2 {
            
        
        //加入切換至設定功能
        } else if indexPath.row == 3 {
            let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        //加入apple內建地圖的導航
        } else if indexPath.row == 4 {
            navigation(lat: 25.052288 , lon: 121.532258, placeName: "ALPHA Camp")
        }
    }
    
    

}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!CollectionViewCell
        cell.myLabel.text = cellContent[indexPath.row]
        
        //cell顯示藍色
        if indexPath.row == 1 {
            cell.backgroundColor = UIColor.blue
            return cell
        }
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    //調整 cell 的大小，服從 UICollectionViewDelegateFlowLayout 協定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //cell 的長寬隨畫面大小不同而改變
        return CGSize(width: (view.frame.width - 80) / 2, height: (view.frame.width - 80) / 2)
    }
}
