import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  
  
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    // Add the email and password fields to your view hierarchy
    view.addSubview(loginButton)
    view.addSubview(registerButton)

    loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
  }
  
  @objc func login() {
    let email = emailField.text!
    let password = passwordField.text!
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if let error = error {
        // Display an alert with the error message
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      } else {
        // Login successful, navigate to the app's main view
      }
    }
  }

  
  @objc func register() {
    let email = emailField.text!
    let password = passwordField.text!
    
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        // Registration successful, navigate to the app's main view
      }
    }
  }
}
