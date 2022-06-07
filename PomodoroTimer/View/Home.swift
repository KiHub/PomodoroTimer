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
            Spacer()
            
            GeometryReader { proxy in
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color("Yellow").opacity(0.15))
                            .blur(radius: 45)
                            .padding(-40)
                        
                        Circle()
                            .fill(Color("DarkYellow").opacity(0.30))
                            .blur(radius: 15)
                            .padding(-40)
                            .shadow(radius: -10)
                        
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.05), lineWidth: 80)
                        //  .padding(-40)
                        
                        //MARK: - Shadow
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(Color("Yellow"), lineWidth: 20)
                            .blur(radius: 10)
                            .padding(-2)
                        
                        Circle()
                            .fill(Color("BG"))
                            .shadow(color: Color("DarkYellow"), radius: 100, x: 0, y: 0)
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                        //   .stroke(style: StrokeStyle(lineCap: .round))
                            .stroke(Color("Yellow").opacity(0.8), style: StrokeStyle(lineWidth: 16, dash: [2, 2]))
                        
                        
                        //MARK: - Button
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("Yellow"))
                                .frame(width: 30, height: 30, alignment: .center)
                                .overlay(content: {
                                    Circle()
                                        .fill(Color("BG"))
                                        .padding(5)
                                })
                                .shadow(color: Color("DarkYellow"), radius: 10, x: 0, y: 0)
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                        }
                        
                        Text(pomodoroModel.timerStringValue)
                            .font(.largeTitle.bold())
                            .foregroundColor(Color("DarkYellow"))
                            .shadow(color: Color("Yellow"), radius: 38, x: 0, y: 0)
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: pomodoroModel.progress)
                        
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0.2))
                    .padding(50)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: pomodoroModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button {
                        if pomodoroModel.isStarted {
                            pomodoroModel.stopTimer()
                            UNUserNotificationCenter.current()
                                .removeAllPendingNotificationRequests()
                        } else {
                            pomodoroModel.addNewTimer = true
                        }
                    } label: {
                        Image(systemName: !pomodoroModel.isStarted ? "timer" : "stop")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color("DarkYellow"))
                            .frame(width: 80, height: 80)
                            .background {
                                Circle()
                                    .fill(Color("Yellow"))
                            }
                            .shadow(color: Color("DarkYellow"), radius: 10, x: 0, y: 0)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
        }
        .padding()
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay(content: {
            ZStack {
                Color.black
                    .opacity(pomodoroModel.addNewTimer || pomodoroModel.isFinishedScreen ? 0.55 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        pomodoroModel.hour = 0
                        pomodoroModel.minute = 0
                        pomodoroModel.seconds = 0
                        pomodoroModel.addNewTimer = false
                        pomodoroModel.isFinishedScreen = false
                        pomodoroModel.stopTimer()
                    }
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: pomodoroModel.addNewTimer ? 0 : 400)
                NewFinishView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: pomodoroModel.isFinishedScreen ? 0 : 400)
            }
            .animation(.easeInOut, value: pomodoroModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if pomodoroModel.isStarted {
                pomodoroModel.updateTimer()
            }
        }
        .fullScreenCover(isPresented: $pomodoroModel.showOnboarding) {
            Onboarding(showOnboarding: $pomodoroModel.showOnboarding)
        }
    }
    
    //MARK: - New Finish Message
    @ViewBuilder
    func NewFinishView() -> some View {
        VStack(spacing: 15) {
            Text("✅ Well done!")
                .foregroundColor(Color("DarkYellow"))
                .font(.title.bold())
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                Button {
                    pomodoroModel.isFinishedScreen = false
                    pomodoroModel.stopTimer()
                    pomodoroModel.addNewTimer = true
                } label: {
                    Text("Start new")
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
                
                Button {
                    pomodoroModel.repeatPrepare()
                    pomodoroModel.isFinishedScreen = false
                    pomodoroModel.totalSeconds = pomodoroModel.staticTotalSeconds
                    pomodoroModel.addNotification()
                    // pomodoroModel.startTimer()
                } label: {
                    Text("Repeat")
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
            }
            .padding(.top, 20)
            
            Button {
                pomodoroModel.stopTimer()
                pomodoroModel.isFinishedScreen = false
            } label: {
                Text("Close")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Yellow"))
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(Color("BG").opacity(0.8))
                    }
                    .padding(.top)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            
            
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("Yellow"), Color("DarkYellow").opacity(0.9)]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
        }
    }
    
    
    //MARK: - New Timer
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15) {
            Text("Add new focus timer")
                .foregroundColor(Color("DarkYellow"))
                .font(.title.bold())
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                Text("\(pomodoroModel.hour) h")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Yellow"))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(Color("DarkYellow").opacity(0.8))
                    }
                    .contentShape(.contextMenuPreview, Capsule())
                    .contextMenu {
                        ContextMenuOptions(maxValue: 12, hint: "h") { value in
                            pomodoroModel.hour = value
                        }
                    }
                
                Text("\(pomodoroModel.minute ) m")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Yellow"))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(Color("DarkYellow").opacity(0.8))
                    }
                
                    .contentShape(.contextMenuPreview, Capsule())
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "m") { value in
                            pomodoroModel.minute = value
                            
                        }
                    }
                
                Text("\(pomodoroModel.seconds) s")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Yellow"))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(Color("DarkYellow").opacity(0.8))
                    }
                    .contentShape(.contextMenuPreview, Capsule())
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "s") { value in
                            pomodoroModel.seconds = value
                        }
                    }
                
            }
            .padding(.top, 20)
            
            Button {
                pomodoroModel.startTimer()
                pomodoroModel.addNewTimer = false
            } label: {
                Text("Start")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Yellow"))
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(Color("BG").opacity(0.8))
                    }
                    .disabled(pomodoroModel.seconds == 0 )
                    .opacity(pomodoroModel.seconds == 0 ? 0.5 : 1)
                    .padding(.top)
            }
            
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("Yellow"), Color("DarkYellow").opacity(0.9)]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
        }
    }
    
    //MARK: - Context Menu
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
        
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomodoroModel())
    }
}
