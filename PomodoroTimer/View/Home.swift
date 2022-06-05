//
//  Home.swift
//  PomodoroTimer
//
//  Created by  Mr.Ki on 05.06.2022.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        VStack {
            Text("Pomodoro focus timer")
                .foregroundColor(Color("Yellow"))
                .font(.title.bold())
                .foregroundColor(.white)
            
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.05))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.05), lineWidth: 80)
                          //  .padding(-40)
                        
                        //MARK: - Shadow
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(Color("Yellow"), lineWidth: 10)
                            .blur(radius: 15)
                            .padding(-2)
                        
                        Circle()
                            .fill(Color("BG"))
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(Color("Yellow")
                                .opacity(0.8), lineWidth: 15)
                        
                        //MARK: - Button
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("Yellow"))
                                .frame(width: 30, height: 30, alignment: .center)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                            
                        }
                        
                    }
                    .padding(50)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
        }
        .padding()
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
            .environmentObject(PomodoroModel())
    }
}
