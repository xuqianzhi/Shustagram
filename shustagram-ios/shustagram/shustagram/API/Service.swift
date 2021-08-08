//
//  Service.swift
//  shustagram
//
//  Created by 徐乾智 on 7/22/21.
//

import Alamofire

class Service: NSObject {
    
    static let shared = Service()
    
    let baseUrl = "https://shustagram.herokuapp.com"
    
    func login(email: String, password: String, completion: @escaping (AFResult<Data>) -> ()) {
        print("Performing login")
        let params = ["emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/login"
        AF.request(url, method: .put, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                } else {
                    completion(.success(dataResp.data ?? Data()))
                }
            }
    }
    
    func fetchPosts(completion: @escaping (AFResult<[Post]>) -> ()) {
        let url = "\(baseUrl)/post"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                guard let data = dataResp.data else { return }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                } catch {
                    print(error)
                }
            }
    }
    
    func signUp(fullName: String, emailAddress: String, password: String, completion: @escaping (AFResult<Data>) -> ()) {
        let params = ["fullName": fullName, "emailAddress": emailAddress, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/signup"
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                completion(.success(dataResp.data ?? Data()))
            }
    }
    
    func upload(postBody: String, image: UIImage?, progressCompletion: @escaping (Progress) -> (), resultCompletion: @escaping (AFDataResponse<Data>) -> ()) {
        let url = "\(baseUrl)/post"
        AF.upload(multipartFormData: { (formData) in
            formData.append(Data(postBody.utf8), withName: "postBody")
            if let image = image {
                guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
                formData.append(imageData, withName: "imagefile", fileName: "randomfilename", mimeType: "image/jpg")
            }
        }, to: url)
        .uploadProgress { progress in
            progressCompletion(progress)
        }
        .responseData { res in
            resultCompletion(res)
        }
    }
    
    func deletePost(postId: String, completion: @escaping (AFDataResponse<Data?>) -> ()) {
        let url = "\(baseUrl)/post/\(postId)"
        AF.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .response(completionHandler: { res in
                completion(res)
            })
    }
    
    func searchForUsers(completion: @escaping (AFResult<[User]>) -> ()) {
        let url = "\(baseUrl)/search"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                switch dataResponse.result {
                case .success(_):
                    do {
                        let data = dataResponse.data ?? Data()
                        let users = try JSONDecoder().decode([User].self, from: data)
                        completion(.success(users))
                    } catch {
                        print("Error decoding JSON", error)
                    }
                case .failure(let err):
                    completion(.failure(err))
                    return
                }
        }
    }
}
