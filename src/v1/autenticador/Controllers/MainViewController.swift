//
//  ViewController.swift
//  autenticador
//
//  Created by Luiz Antônio da Silva Júnior on 04/01/21.
//

import UIKit

class MainViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, AddOtpProtocol {
    
    @IBOutlet weak var otpsTableView: UITableView!
    var otps: [Otp] = Array<Otp>()
    let backgroundColor = UIColor(red: 20, green: 20, blue: 20, alpha: 0)
    let otpDao = OtpDao()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadOtps()
    }
    
    private func loadOtps() {
       do {
            otps = try otpDao.get()
            self.otpsTableView.reloadData()
       } catch {
           Alert(controller: self).show(message: "Não foi possível ler os OTPs.")
       }
    }
    
    func setupTableView() {
        self.otpsTableView.dataSource = self
        self.otpsTableView.delegate = self
        self.otpsTableView.backgroundColor = backgroundColor
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(refreshTableView) , userInfo: nil, repeats: true)
    }
    
    @objc func refreshTableView() {
        self.otpsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: OtpTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OtpTableViewCell
        let otp = otps[indexPath.section]
        cell.nameLabel?.text = otp.name
        cell.otpLabel?.text = otp.generate()
        cell.timeProgress?.progress = otp.getProgress()
                
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(showDetails))
        cell.addGestureRecognizer(longPress)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "novo",
        let viewController = segue.destination as? NewOtpViewController {
                viewController.delegate = self
        }
    }
    
    func add(_ otp: Otp) {
        do {
            otps.append(otp)
            try otpDao.save(otps)
            self.otpsTableView.reloadData()
        } catch {
            otps.removeLast()
            Alert(controller: self).show(message: "Não foi possível salvar o OTP.")
        }
    }
    
    @objc func showDetails(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let cell = gesture.view as! UITableViewCell
            if let indexPath = self.otpsTableView.indexPath(for: cell) {
                let otp  = otps[indexPath.row]
                
                let acoes = getActions { (alert) in
                    do {
                        self.otps.remove(at: indexPath.row)
                        try self.otpDao.delete(at: indexPath.row)
                        self.otpsTableView.reloadData()
                    } catch {
                        Alert(controller: self).show(message: "Não foi possível remover o OTP.")
                    }
                }
                Alert(controller: self).show(title: otp.name, message: otp.seed, actions: acoes)
            }
        }
    }
    
    func getActions (removerHandler: @escaping (UIAlertAction) -> Void) -> [UIAlertAction] {
       let removeAction =  UIAlertAction(title: "Remover", style: .destructive, handler: removerHandler)
       let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
       
       return [cancelAction, removeAction]
   }
}
