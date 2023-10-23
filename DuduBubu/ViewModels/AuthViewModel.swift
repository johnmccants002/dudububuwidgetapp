//
//  AuthViewModel.swift
//  DuduBubu
//
//  Created by John McCants on 7/2/22.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var isAuthenticating = false
    @Published var error: Error?
    @Published var user: User?
    @Published var requestUsers: [User] = []
    @Published var partner: User?
    @Published var selectedCharacter: Int = 0
    @Published var backgroundColor: Color = Color(.blue)
    @Published var selectedImage: String = "Subject"
    @Published var userSentRequest: SentRequest?
    
    
    static let shared = AuthViewModel()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            print("DEBUG: Successfully logged in")
            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func registerUser(email: String, password: String, username: String, character: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("DEBUG: Error \(error.localizedDescription)")
                return
            }
                    
            guard let user = result?.user else { return }
                    
            let data = [
                "email": email,
                "username": username.lowercased(),
                "uid": user.uid,
                "character": character,
                "widgetImage": character == "Dudu" ? "Dudu4" : "Bubu3",
                "backgroundColor": "#ED6C59FF"
            ]
                    
            Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
                print("DEBUG: Successfully uploaded user data")
                self.userSession = user
                self.fetchUser()
            }
        }
    }
    
    func signout() {
        resetToDefaults()
        try? Auth.auth().signOut()
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            self.user = User(dict: data)
            self.fetchSentRequest()
            
            print("THIS IS THE DATA: \(data)")
            if data["character"] as? String == "Dudu" {
                self.selectedCharacter = 0
            } else {
                self.selectedCharacter = 1
            }
            
            if let color = data["backgroundColor"] as? String {
                self.backgroundColor = Color.init(description: color) ?? Color.blue
                
            }
            
            if let widgetImage = data["widgetImage"] as? String {
                self.selectedImage = widgetImage
            }
            
            if let userPartner = data["partner"] as? String {
                COLLECTION_USERS.document(userPartner).getDocument { snapshot, err in
                    if let err = err {
                        print(err)
                    }
                    guard let data = snapshot?.data() else { return }
                    self.partner = User(dict: data)
                }
            }
        }
    }
    
    func searchQueryUsers(text: String, completion: @escaping (User?) -> Void) {
        guard let currentUser = user else { return }
        COLLECTION_USERS.whereField("username", isEqualTo: text.lowercased()).getDocuments { snapshot, err in
            if let err = err {
                print(err.localizedDescription)
                completion(nil) // Pass nil or appropriate error message
                return
            }
            
            guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                completion(nil)
                return
            }
            
            let user = snapshot.documents[0].data()
            let selectedUser = User(dict: user)
            
            if selectedUser.partner != nil {
                completion(nil)
                return
            }
            
            if currentUser.id == selectedUser.id {
                completion(nil)
                return
            }

            completion(selectedUser)
        }
    }
    
    func sendRequest(userId: String, username: String, completion: @escaping (Error?) -> Void) {
        guard let user = user else { return }
        let data = [userId: username]
        COLLECTION_USERS.document(user.id).collection("sent-request").document(user.id).setData(["userId": userId, "username": username]) { err in
            if let err = err {
                print("Error sending request \(err.localizedDescription)")
            }
            self.fetchSentRequest()
        }
        COLLECTION_REQUESTS.document(userId).collection("requests").document(user.id).setData(["userId": user.id]) { err in
            if let err = err {
                print("Error sending request \(err.localizedDescription)")
            }
        }
    }
    
    func acceptRequest(userId: String, username: String, completion: @escaping (Error?) -> Void) {
        let data = [userId: userId, username: username]
        
        guard let user = user else { return }
        
        let group = DispatchGroup()
            
        
        
        self.requestUsers.removeAll()
        
        
        group.enter()
        COLLECTION_USERS.document(userId).collection("sent-request").document(user.id).delete { err in
            if let err = err {
                print(err.localizedDescription)
            }
            group.leave()

        }
        group.enter()
        COLLECTION_REQUESTS.document(user.id).collection("requests").document(userId).delete { err in
            if let err = err {
                print(err.localizedDescription)
            }
            group.leave()

        }
        group.enter()
        COLLECTION_USERS.document(user.id).updateData(["partner": userId]) { err in
            if let err = err {
                print(err.localizedDescription)
            }
            group.leave()

        }
        group.enter()
        COLLECTION_USERS.document(userId).updateData(["partner": user.id]) { err in
            if let err = err {
                print(err.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        let date = Date().formatted(date: .long, time: .omitted)
        COLLECTION_USERS.document(userId).updateData(["partnerSince": date]) { err in
            if let err = err {
                print(err.localizedDescription)
            }
            group.leave()
        }
        
        
        group.notify(queue: .main) {
            self.fetchUser() // Assuming fetchUser is a function of the same class
            Task {
                await self.fetchRequests()
                
            }
            
        }
    }
    
    func denyRequest(userId: String, completion: @escaping (Error?) -> Void) {
        guard let user = user else { return }
        
        let group = DispatchGroup()

        group.enter()
        COLLECTION_USERS.document(userId).collection("sent-request").document(user.id).delete { err in
            if let err = err {
                print(err.localizedDescription)
            }
            group.leave()
        }
        group.enter()
        COLLECTION_REQUESTS.document(user.id).collection("requests").document(userId).delete { err in
            if let err = err {
                print(err.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.fetchUser() // Assuming fetchUser is a function of the same class
            Task {
                await self.fetchRequests()
                
            }
        }
    }
    
    func fetchRequests() async {
        guard let user = user else { return }
        
        do {
            let snapshot = try await COLLECTION_REQUESTS.document(user.id).collection("requests").getDocuments()
                
            var array: [User] = []
                
            for doc in snapshot.documents {
                guard let userId = doc["userId"] as? String else { return }
                let userSnapshot = try await COLLECTION_USERS.document(userId).getDocument()
                guard let data = userSnapshot.data() else { return }
                let requestUser = User(dict: data)
                array.append(requestUser)
            }
                
            self.requestUsers = array
        }
            
        catch {
            print(error)
        }
    }
    
    func removePartner(userId: String) {
        
        guard let user = user else { return }
        
        COLLECTION_USERS.document(userId).updateData(["partner": FieldValue.delete()])
        
        COLLECTION_USERS.document(user.id).updateData(["partner": FieldValue.delete()])
        
        COLLECTION_USERS.document(userId).updateData(["partnerSince": FieldValue.delete()])
        
        COLLECTION_USERS.document(user.id).updateData(["partnerSince": FieldValue.delete()])
        
        self.partner = nil
    }
    
    func updateUserDuduBubu(character: String, completion: @escaping (Error?) -> Void) async {
        guard let user = user else { return }
        
        do {
            try await COLLECTION_USERS.document(user.id).updateData(["character": character])
            completion(nil)
        } catch {
            print(error)
        }
        
        
        
    }
    
    func updateWidget(image: String, backgroundColor: String) {
        guard let user = user else { return }
        
        COLLECTION_USERS.document(user.id).updateData(["widgetImage": image, "backgroundColor": backgroundColor]) { err in
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }
    
    func resetToDefaults() {
        userSession = nil
        isAuthenticating = false
        error = nil
        user = nil
        requestUsers = []
        userSentRequest = nil
        partner = nil
        selectedCharacter = 0
        backgroundColor = Color(.clear)
        selectedImage = "Subject"
    }
    
    func revokeSendRequest(userId: String) {
        guard let user = user else { return }
        
        COLLECTION_USERS.document(user.id).collection("sent-request").document(user.id).delete()
        COLLECTION_REQUESTS.document(userId).collection("requests").document(user.id).delete()
        
        self.userSentRequest = nil
        
    }
    
    func fetchSentRequest() {
        guard let user = user else { return }
        
        COLLECTION_USERS.document(user.id).collection("sent-request").document(user.id).getDocument { snapshot, err in
            if let err = err { print(err.localizedDescription)
                
            }
            
            if let data = snapshot?.data() {
                let request = SentRequest(dict: data)
                self.userSentRequest = request
                
            }
        }

        
    }

}
