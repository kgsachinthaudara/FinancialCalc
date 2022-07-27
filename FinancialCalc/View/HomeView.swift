//
//  ContentView.swift
//  FinancialCalc
//
//  Created by user on 2022-07-26.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTabIndex = 1

    let tabBarIcons = [
        TabItem(title: NSLocalizedString("home", comment: ""), iconName: "rectangle.grid.2x2.fill"),
        TabItem(title: NSLocalizedString("savings", comment: ""), iconName: "person"),
        TabItem(title: NSLocalizedString("mortgage", comment: ""), iconName: "gear"),
        TabItem(title: NSLocalizedString("loan", comment: ""), iconName: "pencil")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTabIndex {
                case 0:
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                case 1:
                    SavingsView()
                case 2:
                    NavigationView {
                        Text("First").navigationTitle("First Tab")
                    }
                case 3:
                    NavigationView {
                        Text("First").navigationTitle("First Tab")
                    }
                case 4:
                    NavigationView {
                        Text("First").navigationTitle("First Tab")
                    }
                default:
                    Text("Remaining tabs")
                }
            }
            
            // Tabbar section
            HStack(alignment: .firstTextBaseline) {
                let selectedTabColor = colorScheme == .dark ? Color(.white) : Color(.black)
                let tabColor = colorScheme == .dark ? Color(.white).opacity(0.5) : .init(white: 0.8)
                
                ForEach(0..<tabBarIcons.count, id: \.self) { index in
                    let isSelected = selectedTabIndex == index
                    let tabItem = tabBarIcons[index]
                    
                    Button(action: {
                        selectedTabIndex = index
                    }, label: {
                        Spacer()
                        if index == 0 {
                            VStack {
                                Image(systemName: tabItem.iconName)
                                    .font(
                                        .system(size: 44, weight: .bold)
                                    )
                                    .foregroundColor(
                                        isSelected ? Color(.orange) : tabColor
                                    )
                                
                                Text(tabItem.title)
                                    .padding(.top, 2)
                                    .foregroundColor(
                                        isSelected ? Color(.orange) : tabColor
                                    )
                                    .font(
                                        .system(size: 10, weight: .heavy, design: .rounded)
                                    )
                            }
                        } else {
                            VStack {
                                Image(systemName: tabItem.iconName)
                                    .font(
                                        .system(size: isSelected ? 28 : 24, weight: .bold)
                                    )
                                    .foregroundColor(
                                        isSelected ? selectedTabColor : tabColor
                                    )
                                
                                Text(tabItem.title)
                                    .padding(.top, 2)
                                    .foregroundColor(
                                        isSelected ? selectedTabColor : tabColor
                                    )
                                    .font(
                                        .system(size: 10, weight: .heavy, design: .rounded)
                                    )
                            }
                        }
                        Spacer()
                    })
                }
            }
            .padding(.top, 8)
            .background(
                Color.white
                    .shadow(color: Color.gray, radius: 8, x: 0, y: 0)
                    .mask(Rectangle().padding(.top, -20))
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.light)
    }
}

// Color(red: 7, green: 158, blue: 245)
