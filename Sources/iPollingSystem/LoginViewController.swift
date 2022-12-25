import Firebase

class LoginViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - Actions

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }

            if let error = error {
                // Handle error
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                strongSelf.present(alertController, animated: true, completion: nil)
                return
            }

            // Login successful
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }

            if let error = error {
                // Handle error
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                strongSelf.present(alertController, animated: true, completion: nil)
                return
            }

            // Registration successful
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
}
