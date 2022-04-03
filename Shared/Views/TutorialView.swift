//
//  TutorialView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/3/29.
//

import SwiftUI

struct TutorialView: View {
    private let pageHeadings = [
        "CREATE YOUR OWN FOOD GUIDE",
        "SHOW YOU THE LOCATION",
        "DISCOVER GREAT RESTAURANTS"
    ]
    private let pageSubHeadings = [
        "Pin your favorite restaurants and create your own food guide",
        "Search and locate your favorite restaurant on Maps",
        "Find restaurants shared by your friends and other foodies"
    ]
    private let pageImages = [
        "onboarding-1",
        "onboarding-2",
        "onboarding-3"
    ]
    
    @AppStorage("hasViewedWalkthrough") private var hasViewedWalkThrough: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPage = 0
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemIndigo
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pageHeadings.count, id: \.self) { index in
                    TutorialPage(image: pageImages[index], heading: pageHeadings[index], subheading: pageSubHeadings[index])
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
            .animation(.default, value: currentPage)
            
            VStack(spacing: 20) {
                Button {
                    if currentPage < pageHeadings.count - 1 {
                        currentPage += 1
                    } else {
                        hasViewedWalkThrough = true
                        dismiss()
                    }
                } label: {
                    Text(currentPage == pageHeadings.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 50)
                        .background(Color(.systemIndigo))
                        .clipShape(Capsule())
                }
                if currentPage < pageHeadings.count - 1 {
                    Button {
                        hasViewedWalkThrough = true
                        dismiss()
                    } label: {
                        Text("Skip")
                            .font(.headline)
                            .foregroundColor(Color(.darkGray))
                    }
                }
            }
            .padding(.bottom)
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}

struct TutorialPage: View {
    let image: String
    let heading: String
    let subheading: String
    
    var body: some View {
        VStack(spacing: 70) {
            Image(image)
                .resizable()
                .scaledToFit()
            VStack(spacing: 10) {
                Text(heading)
                    .font(.headline)
                Text(subheading)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .padding(.top)
    }
}
