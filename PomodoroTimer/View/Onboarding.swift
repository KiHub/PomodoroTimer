//
//  Onboarding.swift
//  PomodoroTimer
//
//  Created by  Mr.Ki on 07.06.2022.
//

import SwiftUI

struct Onboarding: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        TabView {
            PageView(title: "👋 Hey, this is Pocus. Simple and useful focus timer", imageName: "timer", showDismisButton: false, showOnboarding: $showOnboarding)
            
            PageView(title: "✌️ It's the easiest way to beat procrastination - just set a timer and work before the notification coming", imageName: "bell", showDismisButton: false, showOnboarding: $showOnboarding)
            
            PageView(title: "🏆 Are you hard working person? Push repeat!", imageName: "checkmark.bubble", showDismisButton: true, showOnboarding: $showOnboarding)
           
            
         
            
        }
        .background(Color("BG"))
        .tabViewStyle(PageTabViewStyle())
    }
}

struct PageView: View {
    let title: String
    let imageName: String
    let showDismisButton: Bool
    @Binding var showOnboarding: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: imageName)
               // .foregroundColor(Color("DarkYellow"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding()
                .foregroundColor(Color("DarkYellow"))
                .shadow(color: Color("DarkYellow"), radius: 18, x: 0, y: 0)
                
            
            Text(title)
                .foregroundColor(Color("Yellow"))
                .font(.system(size: 28))
                .fontWeight(.thin)
                .padding()
                .shadow(color: Color("Yellow"), radius: 28, x: 5, y: 5)
                .padding(.horizontal)
            Spacer()
            if showDismisButton {
                Button {
                    showOnboarding.toggle()
                } label: {
                    Text("Get started")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Yellow"))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background {
                            Capsule()
                                .fill(Color("DarkYellow").opacity(0.8))
                        }
                }
                .shadow(color: Color("Yellow").opacity(0.8), radius: 18, x: 0, y: 0)
                .padding(.bottom, 80)
            }
            
        }
    }
}

//
//struct Onboarding_Previews: PreviewProvider {
//    static var previews: some View {
//        Onboarding(showOnboarding: $pomodoroModel.showOnboarding)
//    }
//}
