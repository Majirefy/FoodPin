//
//  ReviewView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/3/17.
//

import SwiftUI

struct ReviewView: View {
    var restaurant: Restaurant
    
    @State private var isShowingRatings = false
    
    @Binding var isDisplayed: Bool
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: restaurant.image!)!)
                .resizable()
                .scaledToFill()
                .frame(minWidth:0, maxWidth: .infinity)
                .ignoresSafeArea()
            Color.black
                .opacity(0.6)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            HStack {
                Spacer()
                VStack {
                    Button {
                        withAnimation {
                            isDisplayed = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
            }
            VStack(alignment: .leading, spacing: 32) {
                ForEach(Restaurant.Rating.allCases, id: \.self) { rating in
                    Label(rating.rawValue.capitalized, systemImage: rating.icon)
                        .font(.largeTitle.bold())
                        .symbolVariant(.fill)
                        .foregroundColor(.white)
                        .opacity(isShowingRatings ? 1.0 : 0)
                        .offset(x: isShowingRatings ? 0 : 1000)
                        .animation(.easeOut.delay(Double(Restaurant.Rating.allCases.firstIndex(of: rating)!) * 0.05), value: isShowingRatings)
                        .onTapGesture {
                            withAnimation {
                                restaurant.rating = rating
                                isDisplayed.toggle()
                            }
                        }
                }
            }
        }
        .onAppear {
            isShowingRatings.toggle()
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(restaurant: (PersistenceController.testData?.first)!, isDisplayed: .constant(true))
    }
}
