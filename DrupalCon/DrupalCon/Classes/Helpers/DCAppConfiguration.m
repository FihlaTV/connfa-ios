//
//  DCAppConfiguration.m
//  DrupalCon
//
//  Created by Olexandr on 8/3/15.
//  Copyright (c) 2015 Lemberg Solution. All rights reserved.
//

#import "DCAppConfiguration.h"
#import "DCSideMenuViewController.h"
#import "DCSideMenuType.h"

@implementation DCAppConfiguration
+ (NSArray *)appMenuItems {
    NSArray *menuItems;
#ifdef HCE
   menuItems = @[
        @{ kMenuItemTitle: @"Schedule",
           kMenuItemIcon: @"menu_icon_program",
           kMenuItemSelectedIcon: @"menu_icon_program_sel",
           kMenuItemControllerId: @"DCProgramViewController",
           kMenuType: @(DCMENU_PROGRAM_ITEM)
           },
        @{
            kMenuItemTitle: @"Speakers",
            kMenuItemIcon: @"menu_icon_speakers",
            kMenuItemSelectedIcon: @"menu_icon_speakers_sel",
            kMenuItemControllerId: @"SpeakersViewController",
            kMenuType: @(DCMENU_SPEAKERS_ITEM)
            },
        @{
            kMenuItemTitle: @"My Schedule",
            kMenuItemIcon: @"menu_icon_my_schedule",
            kMenuItemSelectedIcon: @"menu_icon_my_schedule_sel",
            kMenuItemControllerId: @"DCProgramViewController",
            kMenuType: @(DCMENU_MYSCHEDULE_ITEM)
            },
        @{
            kMenuItemTitle: @"Location",
            kMenuItemIcon: @"menu_icon_location",
            kMenuItemSelectedIcon: @"menu_icon_location_sel",
            kMenuItemControllerId: @"LocationViewController",
            kMenuType: @(DCMENU_LOCATION_ITEM)
            },
        @{
            kMenuItemTitle: @"Info",
            kMenuItemIcon: @"menu_icon_about",
            kMenuItemSelectedIcon: @"menu_icon_about_sel",
            kMenuItemControllerId: @"InfoViewController",
            kMenuType: @(DCMENU_INFO_ITEM)
            },
        @{ kMenuItemTitle: @"Time and event place"
           }
        ];
    
#else
    menuItems = @[
                  @{ kMenuItemTitle: @"Sessions",
                     kMenuItemIcon: @"menu_icon_program",
                     kMenuItemSelectedIcon: @"menu_icon_program_sel",
                     kMenuItemControllerId: @"DCProgramViewController",
                     kMenuType: @(DCMENU_PROGRAM_ITEM)
                     },
                  @{
                      kMenuItemTitle: @"BoFs",
                      kMenuItemIcon: @"menu_icon_bofs",
                      kMenuItemSelectedIcon: @"menu_icon_bofs_sel",
                      kMenuItemControllerId: @"DCProgramViewController",
                      kMenuType: @(DCMENU_BOFS_ITEM)
                      },
                  @{
                      kMenuItemTitle: @"Social Events",
                      kMenuItemIcon: @"menu_icon_social",
                      kMenuItemSelectedIcon: @"menu_icon_social_sel",
                      kMenuItemControllerId: @"DCProgramViewController",
                      kMenuType: @(DCMENU_SOCIAL_EVENTS_ITEM)
                      },
                  @{
                      kMenuItemTitle: @"Speakers",
                      kMenuItemIcon: @"menu_icon_speakers",
                      kMenuItemSelectedIcon: @"menu_icon_speakers_sel",
                      kMenuItemControllerId: @"SpeakersViewController",
                      kMenuType: @(DCMENU_SPEAKERS_ITEM)
                      },
                  @{
                      kMenuItemTitle: @"My Schedule",
                      kMenuItemIcon: @"menu_icon_my_schedule",
                      kMenuItemSelectedIcon: @"menu_icon_my_schedule_sel",
                      kMenuItemControllerId: @"DCProgramViewController",
                      kMenuType: @(DCMENU_MYSCHEDULE_ITEM)
                      },
                  @{
                      kMenuItemTitle: @"Location",
                      kMenuItemIcon: @"menu_icon_location",
                      kMenuItemSelectedIcon: @"menu_icon_location_sel",
                      kMenuItemControllerId: @"LocationViewController",
                      kMenuType: @(DCMENU_LOCATION_ITEM)
                      },
                  @{
                      kMenuItemTitle: @"Info",
                      kMenuItemIcon: @"menu_icon_about",
                      kMenuItemSelectedIcon: @"menu_icon_about_sel",
                      kMenuItemControllerId: @"InfoViewController",
                      kMenuType: @(DCMENU_INFO_ITEM)
                      },
                  @{ kMenuItemTitle: @"Time and event place"
                     }
                  ];
    
#endif

    return menuItems;
}



@end
