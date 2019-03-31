//
//  MainViewController.swift
//  简单通信
//
//  Created by 方瑾 on 2019/3/6.
//  Copyright © 2019 方瑾. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTableView: UITableView!
    let strUrl = "https://randomuser.me/api/"
    var session: URLSession?
    var theUser: userInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession(configuration: .default)
        photoTableView.delegate = self
        photoTableView.dataSource = self
        getData(strUrl: strUrl)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTouch))
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
        photoImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func tapTouch() {
        getData(strUrl: strUrl)
       
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
        photoImageView.layer.masksToBounds = true
    }
    func getData(strUrl:String) {
        if let realUrl = URL(string: strUrl) {
            let task = session?.dataTask(with: realUrl, completionHandler: {
                (data,response,error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let downloadData = data {
                    do {
                        let randomData = try JSONDecoder().decode(RandomUser.self, from: downloadData)//复杂的用这个
                        print(randomData)
//                        let json = try JSONSerialization.jsonObject(with: downloadData, options: [])//options想做下载之外的动作，就得写处理//简单的用这个
//                        DispatchQueue.main.async {
//                            self.parseJson(jsonData: json)
//                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            })
            task?.resume()
        }
    }
    
    func parseJson(jsonData:Any?) {
        if let json = jsonData as? [String:Any] {
            if let resultsArray = json["results"] as? [[String:Any]] {
                let email = resultsArray[0]["email"] as? String ?? ""
                let phone = resultsArray[0]["phone"] as? String ?? ""
                var fullName = ""
                if let nameDict = resultsArray[0]["name"] as? [String:String] {
                    let firstName = nameDict["first"] ?? ""
                    let lastName = nameDict["last"] ?? ""
                    fullName = "\(firstName)\(lastName)"
                }
                var address = ""
                if let addressDict = resultsArray[0]["location"] as? [String:Any?] {
                    let state = addressDict["state"] as? String ?? ""
                    let street = addressDict["street"] as? String ?? ""
                    address = "\(state),\(street)"
                }
                var birth = ""
                if let birthDict = resultsArray[0]["dob"] as? [String:Any] {
                    if let fullBirth = birthDict["date"] as? String {
                        birth = String(fullBirth.prefix(10))
                    }
                    if let pictureDict = resultsArray[0]["picture"] as? [String:String] {
                        if let strUrl = pictureDict["large"] {
                            self.downloadPicture(strUrl: strUrl)
                        }
                    }
                }
                theUser = userInfo(name: fullName, email: email, birth: birth, address: address, phone: phone)
                print(theUser)
                photoTableView.reloadData()
            }
        }
    }
    func downloadPicture(strUrl:String) {
        if let url = URL(string: strUrl) {
            let task = session?.downloadTask(with:url,completionHandler: {
                (url,response,error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let realUrl = url {
                    do {
                        let webImage = UIImage(data: try Data(contentsOf: realUrl))
                        DispatchQueue.main.async {
                           self.photoImageView.image = webImage
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
            task?.resume()
        }
        
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! FirstTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "My name is"
            cell.detailLabel.text = theUser?.name ?? ""
        case 1:
            cell.titleLabel.text = "My birthday is"
            cell.detailLabel.text = theUser?.birth ?? ""
        case 2:
            cell.titleLabel.text = "My email is"
            cell.detailLabel.text = theUser?.email ?? ""
        case 3:
            cell.titleLabel.text = "My address is"
            cell.detailLabel.text = theUser?.address ?? ""
        case 4:
            cell.titleLabel.text = "My tellphone number is"
            cell.detailLabel.text = theUser?.phone ?? ""
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
