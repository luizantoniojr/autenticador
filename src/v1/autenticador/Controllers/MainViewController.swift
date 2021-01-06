//
//  ViewController.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 04/01/21.
//

import UIKit

class MainViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var otpsTableView: UITableView!
    var otps: [Otp] = Array<Otp>()
    let backgroundColor = UIColor(red: 20, green: 20, blue: 20, alpha: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        otps.append(Otp("3903688", 335412))
        otps.append(Otp("U003337", 324567))
    }
    
    func setupTableView() {
        self.otpsTableView.dataSource = self
        self.otpsTableView.delegate = self
        self.otpsTableView.backgroundColor = backgroundColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: OtpTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OtpTableViewCell
        let otp = otps[indexPath.section]
        cell.nameLabel?.text = otp.name
        cell.otpLabel?.text = String(otp.value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 100 : 190;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return otps.count
    }
}
