 //
 //  RegisterViewController.swift
 //  SiposSocialMedia
 //
 //  Created by Sipos Péter on 2019. 05. 05..
 //  Copyright © 2019. Sipos Péter. All rights reserved.
 //
 
 import UIKit
 import Foundation
 import SystemConfiguration
 import FirebaseAuth
 import FirebaseFirestore
 
 class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alap()
        InternetCheck()
        hatter()
    }
    
    private var authUser : MyUser? {
        return Auth.auth().currentUser // error: Cannot convert return expression of type 'User?' to return type 'MyUser?'
    }
    
    var msg = String()
    var ttl = String()
    func hatter() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 120/255, green: 110/255, blue: 250/255, alpha: 1).cgColor,#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
    
    func alap() {
        // ezt megcsinalni szepre
        /*
         emailTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
         emailTextField.layer.borderWidth = 5
         passwordTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
         passwordAgainTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
         */
        emailTextField.text = ""
        passwordTextField.text = ""
        passwordAgainTextField.text = ""
        passwordAgainTextField.returnKeyType = .done
    }
    
    // atraktam firebaseba és mukodik gecijol
    func readTxt() {
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/sipossocialmedia.appspot.com/o/forbidden_pw.txt?alt=media&token=78b86db9-f427-4913-a04f-89af6c2324da") {
            do {
                let contents = try String(contentsOf: url)
                let alma : String = passwordTextField.text!
                if contents.contains(alma) {
                    self.msg = "A jelszavad könnyen feltörhető"
                    self.ttl = "Kérlek válassz egy újat."
                    self.alert()
                    alap()
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            self.msg = "Sikertelen csatlakozás az adatbázishoz"
            self.ttl = "Kérlek próbálkozz később"
            self.alert()
        }
    }
    
    func InternetCheck() {
        if ReachabilityTest.isConnectedToNetwork() {
            return
        } else{
            self.msg = "Sikertelen csatlakozás az internethez"
            self.ttl = "Ellenőrizd az internet kapcsolatodat"
            self.alert()
        }
    }
    
    public class ReachabilityTest {
        
        class func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
            
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
    }
    
    func didTapSignUpButton() {
        
        if passwordTextField.text == "" || passwordAgainTextField.text == "" {
            self.msg = "Kérlek minden mezőt tölts ki"
            self.ttl = "Ha kész, nyomj a regisztráció gombra."
            self.alert()
        }
        
        if passwordTextField.text == emailTextField.text || passwordAgainTextField.text == emailTextField.text {
            self.msg = "A felhasználónév és jelszó nem egyezhet"
            self.ttl = "Kérem válasszon más jelszót."
            self.alert()
            alap()
        }
        
        if passwordTextField.text!.count < 7 && passwordAgainTextField.text!.count < 7 {
            self.msg = "A jelszó túl rövid"
            self.ttl = "Kérlek adj meg egy hosszabb jelszót a biztonság érdekében."
            self.alert()
            alap()
        } else {
            if passwordTextField.text == passwordAgainTextField.text {
                readTxt()
            } else {
                self.msg = "A jelszó és jelszó megerősító mező nem egyezik"
                self.ttl = "Kérlek ugyan azt a jelszót írd be."
                self.alert()
                alap()
            }
        }
        
        Auth.auth().fetchProviders(forEmail: emailTextField.text ?? "", completion: {
            (providers, error) in
            // szar
            // de ha letezore regisztralsz akk a providersben lesz az az email
            // ha nem akkor a providers nil lesz
            // tehat at kell irni,hogy ha a providers nil akk legyen a password check
            // különben meg sikertelen regisztracio mert mar letezik a user
            
            if providers == nil {
                if self.passwordTextField.text == self.passwordAgainTextField.text && self.passwordTextField.text!.count > 7 && self.passwordAgainTextField.text!.count > 7 {
                    
                    Auth.auth().createUser(withEmail: (self.emailTextField.text ?? ""), password: (self.passwordTextField.text ?? "")) { (result, error) in
                        if let _eror = error {
                            //something bad happning
                            print(_eror.localizedDescription )
                        }else{
                            //user registered successfully
                            self.msg = "Most jelentkezz be."
                            self.ttl = "A regisztráció sikerült"
                            // megerősítő email
                            self.sendVerificationMail()
                            // lehet megoldottam azzal, hogy atirtam Firebaseban a Rulesban a allow read, write: if false; -t allow read, write: if true; -ra
                            // MŰKÖDIK!
                            
                            Firestore.firestore().collection("users").addDocument(data: [
                                "email": self.emailTextField.text!,
                                "password": self.passwordTextField.text!,
                                "photo_url": "",
                                "verified": false
                                // es talald ki h hova tölti fel a kepet
                                // profilviewcontrolleren kepfeltöltés után szerezd meg az urlt és tedd bele a phot_url: be
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    return
                                }
                            }
                        }
                    }
                    self.alert()
                }
            } else {
                let alertController = UIAlertController(title: "A user már létezik", message: "", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
                self.alap()
            }
            
        })
        
    }
    
    func sendVerificationMail() {
        if self.authUser != nil && !(self.authUser!.isEmailVerified != nil) {
            self.authUser!.sendEmailVerification(completion: { (error) in // error: Cannot call value of non-function type 'String?'
                // Notify the user that the mail has sent or couldn't because of an error.
                self.msg = ""
                self.ttl = "A megerősítő emailt elküldtük"
                self.alert()
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
            self.msg = ""
            self.ttl = "A felhasználó már meg van erősítve"
            self.alert()
        }
    }
    
    func alert() {
        let alertController = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    
    @IBAction func didTapSUButton(_ sender: Any) {
        didTapSignUpButton()
        readTxt()
    }
 }
