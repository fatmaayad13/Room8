//
//  AuthComponents.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct Room8LogoHeader: View {
    var height: CGFloat = 160

    var body: some View {
        Image("room8_logo")
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .padding(.top, 12)
            .accessibilityLabel("room8 logo")
    }
}

struct OrDivider: View {
    var body: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Color.black.opacity(0.10)).frame(height: 1)
            Text("or")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black.opacity(0.45))
            Rectangle().fill(Color.black.opacity(0.10)).frame(height: 1)
        }
        .padding(.vertical, 6)
    }
}

struct IconOnlySocialButton: View {
    let assetName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                )
        }
        .buttonStyle(.plain)
    }
}

struct IconOnlySystemButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: systemName)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                )
        }
        .buttonStyle(.plain)
    }
}

struct SocialPillButton: View {
    let assetName: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)

                Text(text)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black.opacity(0.85))

                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(Color.white)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

struct SocialPillSystemButton: View {
    let systemName: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)

                Text(text)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black.opacity(0.85))

                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(Color.white)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

struct SocialPillSystemLabel: View {
    let systemName: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)

            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.85))

            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 54)
        .background(Color.white)
        .cornerRadius(16)
    }
}
