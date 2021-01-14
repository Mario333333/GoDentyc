//
//  HomeViewController.swift
//  GoDentyc
//
//  Created by Mario Cesar Gaytan Cruz on 23/11/20.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

// pasos firestore 1
import FirebaseFirestore
enum ProviderType: String{
    case basic
    case facebook
    case apple
}

class HomeViewController: UIViewController {
  
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var masterView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonSignOut: UIButton!
    
    let principalBackgroundcolor = UIColor(displayP3Red: 0, green: 204, blue: 255, alpha: 0)
    var tapGestureRecognizer:UITapGestureRecognizer!
    // 2 instancia de conexion a la base
    
    private let db = Firestore.firestore()
   
    let email: String
    let provider: ProviderType
    
    
    init(email:String, provider: ProviderType) {
        self.email = email
        self.provider = provider
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let heightViews = stackView.frame.size.width-10
        navigationItem.setHidesBackButton(true, animated: false)
        title = "Home"
        editButtonItem.isEnabled = true
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutAction))

        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue,forKey: "provider")
        defaults.synchronize()
        
        
        db.collection("modules").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clickAction(_:)))
             
                    let currentStackViewH = UIStackView()
                    currentStackViewH.axis  = NSLayoutConstraint.Axis.horizontal
                    currentStackViewH.distribution  = UIStackView.Distribution.fillEqually
                    currentStackViewH.spacing   = 10
                    currentStackViewH.alignment = UIStackView.Alignment.center
                    currentStackViewH.translatesAutoresizingMaskIntoConstraints = false
                    
                  
 
                    
                    
                    
                    

                    if let submodules = document.get("submodules") as? Array<Any> {
                        for item in submodules {
                            let currentLabelId = UILabel()
                            let currentImage = UIImageView()
                            let currentStackViewV = UIStackView()
                            currentStackViewV.axis  = NSLayoutConstraint.Axis.vertical
                            currentStackViewV.distribution  = UIStackView.Distribution.fillEqually
                            currentStackViewV.spacing   = 10
                            currentStackViewV.alignment = UIStackView.Alignment.center
                            currentStackViewV.translatesAutoresizingMaskIntoConstraints = false
                            currentStackViewV.heightAnchor.constraint(equalToConstant: heightViews/2).isActive = true
                            currentStackViewV.backgroundColor = UIColor.red
                            currentStackViewV.layer.borderWidth = 1
                            currentStackViewV.layer.cornerRadius = 35
                            currentStackViewV.layer.borderColor =  UIColor.white.withAlphaComponent(0.0).cgColor
                            currentStackViewV.backgroundColor = .white
                           
                            print("item: \(item)")
                            if let itemSubModule = item  as? [String: Any] {
                                print("item: \(itemSubModule)")
                                if let image = itemSubModule["image"]  as? String {
                                    print("IMAGE: \(image)")
                                    
                                    currentImage.image = UIImage(systemName: image)
                                    currentImage.contentMode = .scaleAspectFill
                                    currentStackViewV.addArrangedSubview(currentImage)
                                    
                                }
                                if let name = itemSubModule["name"]  as? String {
                                    print("NAME: \(name)")
                                    currentLabelId.text = name
                                    currentLabelId.textAlignment = .center
                                    currentLabelId.textColor = .black
                                    currentLabelId.layer.masksToBounds = true; // to enable bounds radious
                                    currentLabelId.isUserInteractionEnabled = true
                                    currentLabelId.addGestureRecognizer(tapGestureRecognizer)
                                    currentStackViewV.addArrangedSubview(currentLabelId)
                                }
                            }
                            
                            currentStackViewH.addArrangedSubview(currentStackViewV)
                        }
                        
                        
                    }


                   
                    self.stackView.addArrangedSubview(currentStackViewH)
                    
                    
                   
                }
            }
        }
        
        
//        db.collection("modules").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//
//                    let currentStackViewH = UIStackView()
//
//                    let currentLabelId = UILabel()
//                    let currentImage = UIImageView()
//
//                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clickAction(_:)))
//
//                    currentStackViewH.axis  = NSLayoutConstraint.Axis.horizontal
//                    currentStackViewH.distribution  = UIStackView.Distribution.fillEqually
//                    currentStackViewH.spacing   = 10
//                    currentStackViewH.alignment = UIStackView.Alignment.center
//                    currentStackViewH.translatesAutoresizingMaskIntoConstraints = false
//
//                    //setLabelID
//
//                    if let title = document.get("Title") as? String {
//                        currentLabelId.text = title
//                    }
//
//
//                    currentLabelId.textAlignment = .center
//                    currentLabelId.textColor = .black
//                    currentLabelId.layer.masksToBounds = true; // para que agarre el radius
//                    currentLabelId.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
//                    currentLabelId.isUserInteractionEnabled = true
//
//                    currentLabelId.addGestureRecognizer(tapGestureRecognizer)
//                    currentLabelId.layer.borderWidth = 3
//                    currentLabelId.layer.borderColor =  UIColor.white.cgColor
//                    currentLabelId.backgroundColor = .white
//                    currentLabelId.layer.cornerRadius = 35
//
//                    currentImage.image = UIImage(systemName: "info.circle")
//                    currentImage.layer.borderWidth = 1
//                    currentImage.layer.cornerRadius = 35
//                    currentImage.layer.borderColor =  UIColor.white.cgColor
//                    currentImage.backgroundColor = .white
//                    currentImage.contentMode = .scaleAspectFill
//                    currentImage.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
//
//
//                    currentStackViewH.addArrangedSubview(currentImage)
//                    currentStackViewH.addArrangedSubview(currentLabelId)
//
//                    self.stackView.addArrangedSubview(currentStackViewH)
//                }
//            }
//        }
    
        
        
//        NetworkingProvider.shared.getServices { (services) in
//
//            for service in services {
//                let currentStackViewH = UIStackView()
//                let currentStackViewV = UIStackView()
//
//                let currentLabelId = UILabel()
//                let currentImage = UIImageView()
//                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clickAction(_:))) // solo se puede agregar a un elemento por iteracion en este caso estamos creando 2 elementos pero se agrega solo a label  en este caso label
//
//                currentStackViewH.axis  = NSLayoutConstraint.Axis.horizontal
//                currentStackViewH.distribution  = UIStackView.Distribution.fillEqually
//                currentStackViewH.spacing   = 10
//                currentStackViewH.alignment = UIStackView.Alignment.center
//                currentStackViewH.translatesAutoresizingMaskIntoConstraints = false
//
//
//                currentStackViewV.axis  = NSLayoutConstraint.Axis.horizontal
//                currentStackViewV.distribution  = UIStackView.Distribution.fillEqually
//                currentStackViewV.spacing   = 10
//                currentStackViewV.alignment = UIStackView.Alignment.center
//                currentStackViewV.backgroundColor = .white
//                currentStackViewV.layer.borderWidth = 1
//                currentStackViewV.layer.cornerRadius = 35
//                currentStackViewV.layer.borderColor = UIColor.white.cgColor
//                currentStackViewV.translatesAutoresizingMaskIntoConstraints = false
//
//
//                //setLabelID
//                currentLabelId.text = String(service.id!)
//                currentLabelId.textAlignment = .center
//                currentLabelId.textColor = .black
//                currentLabelId.layer.masksToBounds = true; // para que agarre el radius
//                currentLabelId.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
//                currentLabelId.isUserInteractionEnabled = true
//
//                currentLabelId.addGestureRecognizer(tapGestureRecognizer)
//                currentLabelId.layer.borderWidth = 3
//                currentLabelId.layer.borderColor =  UIColor.white.cgColor
//                currentLabelId.backgroundColor = .white
//                currentLabelId.layer.cornerRadius = 35
//
//                currentImage.image = UIImage(systemName: "info.circle")
//                currentImage.layer.borderWidth = 1
//                currentImage.layer.cornerRadius = 35
//                currentImage.layer.borderColor =  UIColor.white.cgColor
//                currentImage.backgroundColor = .white
//                currentImage.contentMode = .scaleAspectFill
//                currentImage.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
//
//
//                currentStackViewH.addArrangedSubview(currentImage)
//                currentStackViewH.addArrangedSubview(currentLabelId)
//
//
//
//                self.stackView.addArrangedSubview(currentStackViewH)
//
//            }
//
//        } failure: { (error) in
//            //
//        }
//


//        
//        buttonSignOut.layer.borderWidth = 1
//        buttonSignOut.layer.cornerRadius = 15
//        buttonSignOut.layer.borderColor = UIColor.white.cgColor
       
    }
    
    @objc func clickAction(_ sender:UITapGestureRecognizer){
        print(sender.view!)
        UIView.animate(withDuration: 1, delay: 0,options: [.allowUserInteraction, .overrideInheritedOptions, .curveEaseOut],
            animations: {
            sender.view!.layer.opacity = 0
            sender.view!.layer.opacity = 1
       })
    }
    
    @objc  func logOutAction(_ sender: Any) {
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        vc.preferredContentSize = CGSize(width: 200, height: 200)
        vc.modalPresentationStyle = .popover
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .left
        ppc?.delegate = self
        ppc!.sourceView = sender as? UIView
        ppc?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
        
        

        

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        switch provider {
            case .basic:
                logOutFirebase()

        case .facebook:
            LoginManager().logOut()
            logOutFirebase()
        case .apple:
            logOutFirebase()
        }
        navigationController?.popViewController(animated: true)

        
    }
    private func logOutFirebase () {
        do {
            try Auth.auth().signOut()
        } catch  {
         
        }
    }

}


extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
