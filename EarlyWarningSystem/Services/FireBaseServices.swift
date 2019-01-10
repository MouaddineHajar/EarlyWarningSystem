//
//  FireBaseServices.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/22/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FireBaseServices {
    
    static let shared = FireBaseServices()
    private init() {}
    
    let reference = Database.database().reference()
    typealias completion = (Error?)->Void
    typealias completion2 = (Data?, Error?)->Void
    
    
    func signIn(email : String, pass : String, completionHandler : @escaping completion) {
            Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
               completionHandler(error)
            }
        }
    
    func signUp(user : UserModel, completionHandler : @escaping completion) {
    
        Auth.auth().createUser(withEmail: user.email, password: user.password!) { (result, error1) in
            
            if error1 != nil {
                completionHandler(error1)
            } else {
                
                guard let result = result?.user else { return }
                let userDict = ["FirstName":user.fname,"Lastname":user.lname,"Email":user.email,"Address":user.address,"Phone":user.phone]
                self.reference.child("User").child(result.uid).setValue(userDict, withCompletionBlock: { (error2, ref) in
                    completionHandler(error2)
                })
            }
        }
    }
    
    func resetPassword(email : String, completionHandler : @escaping completion){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                completionHandler(error)
            }
    }
    
    func logOut(completionHandler : @escaping completion) {
        do {
            try Auth.auth().signOut()
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
        
    }
    
    func updatePassword(newPass : String, oldPass : String, completionHandler : @escaping completion) {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: user!.email!, password: oldPass)
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (result, error1) in
            if let error11 = error1 {
                completionHandler(error11)
            } else {
                Auth.auth().currentUser?.updatePassword(to: newPass) { (error2) in
                    completionHandler(error2)
                }
            }
        })
    }
    
    func saveUserImg(img :UIImage, completionHandler : @escaping completion) {
                let user = Auth.auth().currentUser
                let image = img
                let imgData = image.jpegData(compressionQuality: 0)
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                let imgName = "UserImg/\(String(describing: user!.uid)).jpeg"
                var storageRef = Storage.storage().reference()
                storageRef = storageRef.child(imgName)
                storageRef.putData(imgData!, metadata: metaData) { (data, error) in
                    completionHandler(error)
                }
    }
    
    func savePostImg(id : String,img :UIImage,completionHandler : @escaping completion) {
        let image = img
        let imgData = image.jpegData(compressionQuality: 0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imgName = "Post/\(String(describing: id)).jpeg"
        var storageRef = Storage.storage().reference()
        storageRef = storageRef.child(imgName)
        storageRef.putData(imgData!, metadata: metaData) { (data, error) in
            completionHandler(error)
        }
    }
    
    func getPostImg(id : String,completionHandler : @escaping completion2) {
        let imageName = "Post/\(String(describing: id)).jpeg"
        var storageRef : StorageReference?
        storageRef = Storage.storage().reference()
        storageRef = storageRef?.child(imageName)
        storageRef?.getData(maxSize: 1*300*300, completion: { (data, error) in
            completionHandler(data,error)
        })
    }
    
    func getUserImg(completionHandler : @escaping completion2) {
        let user = Auth.auth().currentUser
        let imageName = "UserImg/\(String(describing: user!.uid)).jpeg"
        var storageRef : StorageReference?
        storageRef = Storage.storage().reference()
        storageRef = storageRef?.child(imageName)
        storageRef?.getData(maxSize: 1*300*300, completion: { (data, error) in
           completionHandler(data,error)
        })
    }
    
    func getUserImg(id : String,completionHandler : @escaping completion2) {
        let imageName = "UserImg/\(id).jpeg"
        var storageRef : StorageReference?
        storageRef = Storage.storage().reference()
        storageRef = storageRef?.child(imageName)
        storageRef?.getData(maxSize: 1*300*300, completion: { (data, error) in
            completionHandler(data,error)
        })
    }
    
    func getUser(completionHandler : @escaping (UserModel?)->Void) {
        let user = Auth.auth().currentUser
        reference.child("User").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snap = snapshot.value as? [String:Any]
                else {
                    completionHandler(nil)
                    return
                }
            self.getUserImg(id: user!.uid, completionHandler: { (data, error) in
                let use = UserModel(userID: user!.uid, fname: snap["FirstName"] as! String, lname: snap["Lastname"] as! String, email: user!.email!, address: snap["Address"] as! String , phone: snap["Phone"] as! String, password: nil, image: UIImage(data: data ?? Data()), latitude: (snap["latitude"] as! Double), longitude: (snap["longitude"] as! Double))
                completionHandler(use)
            })
        })
    }
    
    func getUserByID(userID: String, completionHandler : @escaping (UserModel?)->Void) {
        
        reference.child("User").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snap = snapshot.value as? [String:Any]
                else {
                    completionHandler(nil)
                    return
            }
            self.getUserImg(id: userID, completionHandler: { (data, error) in
                let use = UserModel(userID: userID, fname: snap["FirstName"] as! String, lname: snap["Lastname"] as! String, email: snap["Email"] as! String, address: snap["Address"] as! String , phone: snap["Phone"] as! String, password: nil, image: UIImage(data: data ?? Data()), latitude: (snap["latitude"] as! Double), longitude: (snap["longitude"] as! Double))
                completionHandler(use)
            })
        })
    }
    
    func getUsers(completionHandler : @escaping ([UserModel]?)->Void) {
        let userQ = Auth.auth().currentUser
        
        let fetchUserGroup = DispatchGroup()
        let fetchUserComponentsGroup = DispatchGroup()
        fetchUserGroup.enter()
        
        reference.child("User").observeSingleEvent(of: .value) { (snapshot, error) in
            if error == nil {
                var userArray = [UserModel]()
                guard let snap = snapshot.value as? [String:Any]
                    else {
                        completionHandler(nil)
                        return
                }
                for record in snap {
                    let uid : String = record.key
                    if userQ?.uid != uid {
                        let user = snap[uid] as! [String:Any]
                        var userModel = UserModel(userID: uid,
                                                  fname: user["FirstName"] as! String,
                                                  lname: user["Lastname"] as! String,
                                                  email: user["Email"] as! String,
                                                  address: user["Address"] as! String ,
                                                  phone: user["Phone"] as! String,
                                                  password: nil,
                                                  image: nil,
                                                  latitude: (user["latitude"] as! Double),
                                                  longitude: (user["longitude"] as! Double))
                        
                        fetchUserComponentsGroup.enter()
                        self.getUserImg(id: uid, completionHandler: { (data, error) in
                            if error == nil && !(data == nil){
                                userModel.image = UIImage(data: data!)
                            }
                            userArray.append(userModel)
                            fetchUserComponentsGroup.leave()
                        })
                    }
                }
                fetchUserComponentsGroup.notify(queue: .main) {
                    fetchUserGroup.leave()
                }
                
                fetchUserGroup.notify(queue: .main) {
                    completionHandler(userArray)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func getFriends(completionHandler : @escaping ([UserModel]?)->Void) {
        let user = Auth.auth().currentUser
        
        var friendArray : [UserModel] = []
        let friendListdispatchGroup = DispatchGroup()
        self.reference.child("User").child(user!.uid).child("FRIENDS").observeSingleEvent(of: .value) { (snapshot) in
            if let friends = snapshot.value as? [String:Any] {
                for friend in friends {
                    friendListdispatchGroup.enter()
                    
                  self.reference.child("User").child(friend.key).observeSingleEvent(of: .value) { (friendSnapShot) in
                        guard let singleFriend = friendSnapShot.value as? Dictionary<String, Any> else {return}
                    
                        var userModel = UserModel(userID: friend.key,
                                              fname: singleFriend["FirstName"] as! String,
                                              lname: singleFriend["Lastname"] as! String,
                                              email: singleFriend["Email"] as! String,
                                              address: singleFriend["Address"] as! String ,
                                              phone: singleFriend["Phone"] as! String,
                                              password: nil,
                                              image: nil,
                                              latitude: (singleFriend["latitude"] as! Double),
                                              longitude: (singleFriend["longitude"] as! Double))
                    
                        self.getUserImg(id: userModel.userID!, completionHandler: { (data, error) in
                            if error == nil && !(data == nil){
                               userModel.image = UIImage(data: data!)
                            }
                            friendArray.append(userModel)
                            friendListdispatchGroup.leave()
                        })
                    }
                }
                friendListdispatchGroup.notify(queue: .main) {
                    completionHandler(friendArray)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func updateData(use : UserModel, completionHandler : @escaping completion) {
        let user = Auth.auth().currentUser
        let userDict = ["FirstName":use.fname,"Lastname":use.lname,"Address":use.address,"Phone":use.phone]
        self.reference.child("User").child(user!.uid).updateChildValues(userDict) { (error, ref) in
            completionHandler(error)
        }
    }
    
    func addFriend(friendId: String, completionHandler: @escaping completion) {
        let user = Auth.auth().currentUser
        self.reference.child("User").child(user!.uid).child("FRIENDS").updateChildValues([friendId : "FriendID"]) { (error, ref) in
            completionHandler(error)
        }
    }
    
    func removeFriend(friendId: String, completionHandler: @escaping completion) {
        let user = Auth.auth().currentUser
        self.reference.child("User").child(user!.uid).child("FRIENDS").child(friendId).removeValue() { (error, ref) in
            completionHandler(error)
        }
    }
    
    func addPost(img : UIImage , postdesc : String? , completionHandler: @escaping completion) {
        let user = Auth.auth().currentUser
        let postKey = self.reference.child("Post").childByAutoId().key
        let postDict = ["userID" : user?.uid, "describtion" : postdesc ?? "" , "timestamp" : "\(NSDate().timeIntervalSince1970)"]

        self.reference.child("Post").child(postKey!).setValue(postDict) { (error, ref) in
            if error != nil {
                completionHandler(error)
            } else {
                self.savePostImg(id: postKey!, img: img, completionHandler: { (error) in
                    if error != nil {
                        completionHandler(error)
                    } else {
                        completionHandler(nil)
                    }
                })
            }
        }
    }
    
    func getPosts(completionHandler: @escaping ([[String:Any]]?)->Void) {
        
        var postArr = [[String:Any]]()
        let postListdispatchGroup = DispatchGroup()
        let fetchUserComponentsGroup = DispatchGroup()
        
       
        self.reference.child("Post").observeSingleEvent(of: .value) {
            (snapshot) in
            if let posts = snapshot.value as? [String:Any] {
                for record in posts {
                    postListdispatchGroup.enter()
                    let key = record.key
                    let post = posts[key] as! [String:Any]
                    var postDict = [String:Any]()
                    fetchUserComponentsGroup.enter()
                    self.getUserByID(userID: post["userID"] as! String, completionHandler: { (user) in
                        postDict["user"] = user
                        fetchUserComponentsGroup.leave()
                    })
                    postDict["postID"] = key
                    postDict["comment"] = post["describtion"]
                    postDict["timestamp"] = post["timestamp"]
                    
                    self.getPostImg(id: key, completionHandler: { (data, error) in
                        if error == nil && data != nil {
                            postDict["postImg"] = UIImage(data: data!)
                        } else {
                            postDict["postImg"] = nil
                        }
                        fetchUserComponentsGroup.notify(queue: .main) {
                            postArr.append(postDict)
                            postListdispatchGroup.leave()
                        }
                    })
                }
                
                postListdispatchGroup.notify(queue: .main) {
                    completionHandler(postArr)
                }
            }else {
                completionHandler(nil)
            }
            
        }
        
    }
    
    func sendText(message : String, friendID : String, completionHandler: @escaping completion) {
        let user = Auth.auth().currentUser
        let keysorted : [String] = [(user?.uid)!,friendID].sorted(by: {$0>$1})
        let key = "\(keysorted[0])\(keysorted[1])"
        let messKey = "\(Int(NSDate().timeIntervalSince1970))"
        let convoDict = ["message": message, "receiverID": friendID]
        self.reference.child("Conversations").child(key).child(messKey).setValue(convoDict) { (error, ref) in
                completionHandler(error)
        }
    }
    
    func getConvo(friendID : String, completionHandler: @escaping ([Conversation]?)->()) {
        let user = Auth.auth().currentUser
        let keysorted : [String] = [(user?.uid)!,friendID].sorted(by: {$0>$1})
        let key = "\(keysorted[0])\(keysorted[1])"
        var convoArr = [Conversation]()
        self.reference.child("Conversations").child(key).observeSingleEvent(of: .value) {
            (snapshot) in
            
            if let texts = snapshot.value as? [String:Any] {
                for text in texts {
                    let timeStamp = text.key
                    let textMessage = texts[timeStamp] as! [String:String]
                    let message = textMessage["message"]
                    let receiverID = textMessage["receiverID"]
                    convoArr.append(Conversation(message: message!, receiverID: receiverID!, time: timeStamp))
                }
                completionHandler(convoArr)
            } else {
                completionHandler(nil)
            }
            
        }
    }
}


