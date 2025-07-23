//
//  QueueListView.swift
//  VQueue
//
//  Created by Frengky Gunawan on 23/07/25.
//

import SwiftUI

struct QueueListView: View {
    let queueItems: [QueueList] = [
        QueueList(brandName: "Vaseline", location: "Hall A", currentQueue: 1, queueNumber: 9),
        QueueList(brandName: "Nivea", location: "Hall B", currentQueue: 12, queueNumber: 27),
        QueueList(brandName: "Wardah", location: "Hall C", currentQueue: 4, queueNumber: 31),
        
    ]
    
    var body: some View {
        VStack {
            ToolbarQueueListView()
            Divider().background(Color.dividerColor)
                .padding(.vertical, 4)
            ScrollView {
                VStack {
                    ForEach(queueItems) { item in
                        QueueTicketCardView(item: item)
                    }
                    QueueNoteView()
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    QueueListView()
}

struct ToolbarQueueListView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.redColor)
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
            }
            
            Text("Queue List")
                .font(.system(size: 17))
                .fontWeight(.semibold)
            
            Spacer()
        }
    }
}

struct QueueTicketCardView: View {
    var item: QueueList
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Image("bgQueueList")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .scaledToFit()
                
                HStack(alignment: .center) {
                    Text("\(item.queueNumber)")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.25)
                        .background(Color.clear)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.brandName)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        HStack(spacing: 2) {
                            Image("iconLocation")
                                .foregroundColor(.graysColor)
                            
                            Text(item.location)
                                .font(.subheadline)
                                .foregroundColor(.graysColor)
                            Spacer()
                        }
                        
                        Text("Current Queue : \(item.currentQueue)")
                            .font(.footnote)
                            .foregroundColor(.graysColor)
                            .italic()
                            .padding(.bottom, 9)
                        
                    }
                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 17)
        .padding(.top, 12)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = []
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

