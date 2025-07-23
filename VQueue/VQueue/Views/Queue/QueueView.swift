//
//  QueueView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 23/07/25.
//

import SwiftUI

struct QueueView: View {
    @State private var isShowCancelAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                ToolbarQueueView()
                Divider().background(Color.dividerColor)
                    .padding(.vertical, 4)
                
                Text("Your Queue Number")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .padding(.top, 25)
                
                QueueNumberView()
                
                QueueNoteView()
                
                Spacer()
                
                Button(action: {
                    isShowCancelAlert.toggle()
                }) {
                    Text("Cancel Queue")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.redColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.redColor ?? Color.red, lineWidth: 2)
                        )
                        .cornerRadius(12)
                }.padding(.horizontal, 37)
            }.alert("Cancel Queue", isPresented: $isShowCancelAlert) {
                Button("Yes", role: .destructive) {
                    // action will come here
                }
                Button("No", role: .cancel) {
                    isShowCancelAlert.toggle()
                }
                
            } message: {
                Text("You’re about to lose your spot. Are you sure you want to cancel?")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    QueueView()
}


struct ToolbarQueueView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isNavigatingToQueueList = false

    var body: some View {
        NavigationStack {
            HStack(alignment: .center) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.redColor)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                }
                
                Text("Mykonos")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                
                Spacer()
                Button(action: {
                    isNavigatingToQueueList = true
                }) {
                    Image(systemName: "list.bullet.clipboard")
                        .foregroundColor(Color.redColor)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                }
            }
        }.navigationDestination(isPresented: $isNavigatingToQueueList) {
            QueueListView()
        }
    }
}

struct QueueNoteView: View {
    var body: some View {
        Group {
            Text("You’ll be notified ")
            + Text("5 numbers").fontWeight(.semibold)
            + Text(" before your turn.\n")
            + Text("If you’re ")
            + Text("late").fontWeight(.semibold)
            + Text(", your queue goes bye-bye 💨")
        }
        .font(.footnote)
        .multilineTextAlignment(.center)
        .foregroundColor(.black)
        .padding(.top, 25)
    }
}

struct QueueNumberView: View {
    var body: some View {
        ZStack {
            Image("ImageQueueCoupon")
            VStack {
//                Spacer()
                Text("37")
                    .font(.system(size: 100))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 55)
                
//                Spacer()
                HStack  {
                    Spacer()
                    Text("#31AS")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                    Text("25")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom, 50)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.trailing, 25)
            }
        }
        .padding(.top, 25)
    }
}
