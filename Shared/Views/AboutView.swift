//
//  AboutView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/4/3.
//

import SwiftUI

struct AboutView: View {
    private enum WebLink: String, Identifiable {
        case rateUs = "https://www.apple.com/ios/app-store"
        case feedback = "https://augix.me"
        case twitter = "https://www.twitter.com/majirefy"
        case facebook = "https://www.facebook.com/majirefy"
        case instagram = "https://www.instagram.com/majirefy"
        
        var id: UUID {
            UUID()
        }
    }
    
    @State private var webLink: WebLink?
    
    var body: some View {
        NavigationView {
            List {
                Image("about")
                    .resizable()
                    .scaledToFit()
                Section {
                    Link(destination: URL(string: WebLink.rateUs.rawValue)!) {
                        Label("Rate us on App Store", image: "store")
                            .foregroundColor(.primary)
                    }
                    Label("Tell us your feedback", image: "chat")
                        .onTapGesture {
                            webLink = .feedback
                        }
                }
                Section {
                    Label("Twitter", image: "twitter")
                        .onTapGesture {
                            webLink = .twitter
                        }
                    Label("Facebook", image: "facebook")
                        .onTapGesture {
                            webLink = .facebook
                        }
                    Label("Instagram", image: "instagram")
                        .onTapGesture {
                            webLink = .instagram
                        }
                }
            }
            .navigationTitle("About")
            .sheet(item: $webLink) { webLink in
                if let url = URL(string: webLink.rawValue) {
                    SafariView(url: url)
                }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
