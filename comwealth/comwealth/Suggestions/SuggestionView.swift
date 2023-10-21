//
//  SuggestionView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 21.10.23.
//

import SwiftUI

struct SuggestionView: View {
    let ticker: Ticker
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                AreaChart(data: ticker.chartPoints)
                    .frame(height: 192)
            }
            
            TickerDetailsView(ticker: ticker)
        }
        .background(.white)
        .cornerRadius(20)
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .shadow(radius: 4)
    }
}

struct TickerDetailsView: View {
    let ticker: Ticker
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        ticker.image
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white) // change to .accentColor
                            .background(Color.accentColor.opacity(0.5))
                            .clipShape(Circle())
                        
                        Text(ticker.symbol)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .frame(height: 32)
                    
                    HStack {
                        Text(ticker.displayName)
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .frame(height: 32)
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.accentColor)
                    }
                    .frame(height: 32)
                    
                    HStack {
                        Spacer()
                        
                        Text(ticker.displayPerformance)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.accentColor)
                    }
                    .frame(height: 32)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()
            
            HStack {
                Text("Expected returns")
                    .padding()
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionView(ticker: .sample)
            .frame(height: 320)
            .preferredColorScheme(.light)
    }
}
