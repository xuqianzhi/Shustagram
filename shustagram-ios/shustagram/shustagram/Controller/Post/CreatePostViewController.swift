//
//  createPostViewController.swift
//  shustagram
//
//  Created by 徐乾智 on 7/23/21.
//

import LBTATools
import Alamofire
import JGProgressHUD

class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    let selectedImage: UIImage
    
    weak var homeController: HomeViewController? // use this upon dismiss later
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        super.init(nibName: nil, bundle: nil)
        imageView.image = selectedImage
    }
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    lazy var postButton = UIButton(title: "Post", titleColor: .white, font: .boldSystemFont(ofSize: 14), backgroundColor: #colorLiteral(red: 0.1127949134, green: 0.5649430156, blue: 0.9994879365, alpha: 1), target: self, action: #selector(handlePost))
    
    let placeholderLabel: UILabel = {
        let label = UILabel(text: "Enter your post body text... \n \n \n \n", font: .systemFont(ofSize: 14), textColor: .lightGray)
        label.numberOfLines = 5
        return label
    }()
    
    let postBodyTextView = UITextView(text: nil, font: .systemFont(ofSize: 14))
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        placeholderLabel.numberOfLines = 5
        // here is the layout of our UI
        postButton.layer.cornerRadius = 5
    
        view.stack(view.hstack(imageView.withHeight(110).withWidth(110), placeholderLabel, spacing: 16).padLeft(16).padTop(16),
                   view.stack(postButton.withHeight(40)).padLeft(16).padRight(16),
                   UIView(),
                   spacing: 20)

        // setup UITextView on top of placeholder label, UITextView does not have a placeholder property
        view.addSubview(postBodyTextView)
        postBodyTextView.backgroundColor = .clear
        postBodyTextView.delegate = self
        postBodyTextView.anchor(top: imageView.topAnchor, leading: placeholderLabel.leadingAnchor, bottom: imageView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: -6, bottom: 0, right: 16))
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        placeholderLabel.alpha = !textView.text.isEmpty ? 0 : 1
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.alpha = 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.alpha = !textView.text.isEmpty ? 0 : 1
    }
    
    @objc fileprivate func handlePost() {
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Uploading"
        hud.show(in: view)
        
        guard let text = postBodyTextView.text else { return }
        
        Service.shared.upload(postBody: text, image: self.selectedImage) { progress in
            print("Upload progress: \(progress.fractionCompleted)")
            hud.progress = Float(progress.fractionCompleted)
            hud.textLabel.text = "Uploading\n\(Int(progress.fractionCompleted * 100))% Complete"
        } resultCompletion: { res in
            hud.dismiss()
            switch res.result {
            case .failure(let err):
                print("failed to upload the image", err)
                return
            case .success(_):
                if let code = res.response?.statusCode, code >= 300 {
                    print("failed to hit server with status code: ", code)
                    return
                }
//                let respString = String(data: res.data ?? Data(), encoding: .utf8)
                print("Successfully created post, here is the response:")
//                print(respString ?? "")
                self.dismiss(animated: true) {
                    self.refreshPostsForEntireApplication()
                }
            }
        }
    }
    
    func refreshPostsForEntireApplication() {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        guard let mainVC = (keyWindow?.rootViewController) as? MainTabBarController else { return }
        mainVC.refreshPosts()
    }
    
}

