//
//  MainToolbar.swift
//  Redzone
//
//  Created by Greg Whatley on 6/15/25.
//

import SwiftUI

struct MainToolbar: ToolbarContent {
    @AppStorage(AppStorageKeys.autoMoveCamera) private var autoMoveCamera = true
    @Environment(Context.self) private var context
    @Environment(OutlookService.self) private var outlookService
    @Environment(LocationService.self) private var locationService
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                if !locationService.isUpdatingLocation {
                    locationService.requestPermission()
                } else if let location = locationService.lastKnownLocation?.coordinate {
                    context.moveCamera(to: location)
                }
            } label: {
                Image(systemName: "location\(locationService.isUpdatingLocation ? ".fill" : "")")
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                await outlookService.refresh()
                if await autoMoveCamera {
                    await self.context.moveCamera(centering: outlookService.state)
                }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .disabled(outlookService.state == .loading)
        }
    }
}
