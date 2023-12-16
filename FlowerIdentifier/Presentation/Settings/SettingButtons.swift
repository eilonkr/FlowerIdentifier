//
//  SettingButtons.swift
//  writeai
//
//  Created by Eilon Krauthammer on 24/06/2023.
//

import SwiftUI

struct SettingsListButton: View {
    let title: String
    var iconName: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                HStack(spacing: 10.0) {
                    if let iconName {
                        Image(systemName: iconName)
                            .font(.headline)
                    }

                    Text(title)
                        .fontWeight(.medium)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.callout)
                    .foregroundColor(Color(.systemGray2))
            }
        }
        .padding(.horizontal)
        .frame(height: 36.0)
        .listRowInsets(.init(.zero))
    }
}

struct SettingsListShareButton: View {
    let title: String
    let shareURL: URL

    var body: some View {
        ShareLink(item: shareURL) {
            HStack {
                HStack(spacing: 10.0) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.headline)

                    Text(title)
                        .fontWeight(.medium)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.callout)
                    .foregroundColor(Color(.systemGray2))
            }
        }
        .padding(.horizontal)
        .frame(height: 36.0)
        .listRowInsets(.init(.zero))
    }
}
