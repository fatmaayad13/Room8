//
//  SignUpView.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer(minLength: 18)

                Room8LogoHeader(height: 160)

                Text("Create an account")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Theme.navy)

                VStack(spacing: 14) {
                    SocialPillButton(assetName: "facebook_logo", text: "Continue with Facebook") {
                        // TODO later
                    }

                    SocialPillButton(assetName: "google_logo", text: "Continue with Google") {
                        // TODO later
                    }

                    SocialPillSystemButton(systemName: "apple.logo", text: "Continue with Apple") {
                        // TODO later
                    }

                    OrDivider()

                    NavigationLink {
                        SignUpEmailView()
                            .environmentObject(auth)
                    } label: {
                        SocialPillSystemLabel(systemName: "envelope", text: "Sign Up with Email")
                    }
                    .buttonStyle(.plain)
                }
                .padding(18)
                .background(Theme.sand.opacity(0.45))
                .cornerRadius(Theme.cornerXL)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
                .padding(.horizontal, Theme.pad)

                Spacer()
            }
        }
        #if os(iOS)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}



