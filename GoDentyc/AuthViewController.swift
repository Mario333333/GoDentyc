//
//  AuthViewController.swift
//  GoDentyc
//
//  Created by Mario Cesar Gaytan Cruz on 20/11/20.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import CryptoKit
import AuthenticationServices


class AuthViewController: UIViewController {

    @IBOutlet weak var emailTexInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInFacebookButton: UIButton!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var logInButtonApple: UIButton!
    
    let myColor : UIColor = UIColor( red: 0, green: 116, blue:250, alpha: 0.0)
    fileprivate var currentNonce: String?
   
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let loginButton = FBLoginButton()
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        loginButton.center = view.center
//        view.addSubview(loginButton)
        
        
        let userDefaults = UserDefaults.standard
        if let email = userDefaults.value(forKey: "email") as? String , let provider = userDefaults.value(forKey: "provider") as? String {
            myStackView.isHidden = true
            self.navigationController?.pushViewController(HomeViewController(email: email, provider: ProviderType.init(rawValue: provider)!), animated: true)
        }
       
        emailTexInput.layer.borderWidth = 1
        emailTexInput.layer.cornerRadius = 10
        emailTexInput.layer.borderColor = UIColor.white.cgColor
        emailTexInput.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextInput.layer.borderWidth = 1
        passwordTextInput.layer.cornerRadius = 10
        passwordTextInput.layer.borderColor = UIColor.white.cgColor
        passwordTextInput.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        signInButton.layer.borderWidth = 1
        signInButton.layer.cornerRadius = 10
        signInButton.layer.borderColor = UIColor.white.cgColor
        
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderColor = UIColor.white.cgColor
        
        logInFacebookButton.layer.borderWidth = 2
        logInFacebookButton.layer.cornerRadius = 10
        logInFacebookButton.layer.borderColor = myColor.cgColor
        
        logInButtonApple.layer.borderWidth = 2
        logInButtonApple.layer.cornerRadius = 10
        logInButtonApple.layer.borderColor = UIColor.white.cgColor
        
    
       
        

        
    }
    
    @objc func clickAction(_ sender:UITapGestureRecognizer){
        print(sender.view!)
        UIView.animate(withDuration: 1, delay: 0,options: [.allowUserInteraction, .overrideInheritedOptions, .curveEaseOut],
            animations: {
            sender.view!.layer.opacity = 0
            sender.view!.layer.opacity = 1
       })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myStackView.isHidden = false
    }

    @IBAction func signUpAction(_ sender: Any) {
        if let email = emailTexInput.text, let password = passwordTextInput.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                self.showHome(result: authResult, error: error, provider: .basic)
            }
        }
        
    }
    
    @IBAction func facebookLogInAction(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            switch result {
            
            case .success(granted: _, declined: _, token: let token):
                let credencial = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                Auth.auth().signIn(with:credencial) { (result , error) in
                    self.showHome(result: result, error: error, provider: .facebook)
                }
               
            case .cancelled:
                break
            case .failed(_):
                break
            }
        }
    }
    
    @IBAction func appleLoginAction(_ sender: Any) {
        // 1 habilita opción en apple
        // 2 selecciona target del proyecto en signing tab agregar un sisgnin de login de apple
        // 3 En la documentacion de firebase viene el codigo para logeo
        // funcion que genera que se pasara a firebase y apple, para concretar que es la misma peticion y evitar ataques 
        
        // codigo 2 apple
    let nonce = randomNonceString()
      currentNonce = nonce // se pasara al proceso de autenticacion
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email] // datos a solicitar a usuarios
      request.nonce = sha256(nonce) // clave aleatoria que genera la funcion de condigo 1

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self // delega el resultado de la pantalla a esta pantalla
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
        
    }
    private func showHome(result: AuthDataResult?, error: Error?, provider: ProviderType){
        if let result = result, error == nil {
            self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: provider), animated: true)

        }else{
            let alert = UIAlertController(title: "Error", message: "Se ha producido un error", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// functions para login apple
extension AuthViewController {
    
    // codigo 1 apple
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}


extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
          
            if (error == nil) {
            // Error. If error.code == .MissingOrInvalidNonce, make sure
            // you're sending the SHA256-hashed nonce as a hex string with
            // your request to Apple.
         
                self.showHome(result: authResult, error: error, provider: .apple)
            return
          }
          // User is signed in to Firebase with Apple.
          // ...
        }
      }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error")
    }
}
