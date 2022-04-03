//
//  SafariView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/4/3.
//

import Foundation
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ safariViewController: SFSafariViewController, context: Context) {
        
    }
}
