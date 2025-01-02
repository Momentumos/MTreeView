//
//  Constants.swift
//  Momentum
//
//  Created by Mohammad Yeganeh on 12/12/23.
//

import Foundation
import SwiftUI


struct Constants {
    
    static let screenshotInterval: TimeInterval = 5
 
    struct Colors {
        static let clear = Color("colorBackgroundDefault").opacity(0.001)
        struct accent {
            static let alert = Color("colorAccentAlert")
            static let error = Color("colorAccentError")
            static let info = Color("colorAccentInfo")
            static let success = Color("colorAccentSuccess")
            static let chat = Color("colorAccentChat")
        }
        struct background {
            static let active = Color("colorBackgroundActive")
            static let alert = Color("colorBackgroundAlert")
            static let info = Color("colorBackgroundInfo")
            static let main = Color("colorBackgroundDefault")
            static let mainOpaque = Color("colorBackgroundDefault").opacity(0.86)
            static let disabled = Color("colorBackgroundDisabled")
            static let error = Color("colorBackgroundError")
            static let primary = Color("colorBackgroundPrimary")
            static let primaryHover = Color("colorBackgroundPrimaryHover")
            static let secondary = Color("colorBackgroundSecondary")
            static let success = Color("colorBackgroundSuccess")
            static let brand = Color("colorBackgroundBrand")
        }
        
        struct border {
            static let main = Color("ScolorBorderDefault")
            static let mainHover = Color("ScolorBorderDefaultHover")
            static let disabled = Color("colorBorderDisabled")
            static let bold = Color("ScolorBorderBold")
            static let boldHover = Color("ScolorBorderBoldHover")
        }
        struct content {
            static let alternative = Color("colorContentAlternative")
            static let main = Color("colorContentDefault")
            static let mainReverse = Color("colorContentDefaultReverse")
            static let disabled = Color("colorContentDisabled")
            static let secondary = Color("colorContentSecondary")
            static let inactive = Color("colorContentInactive")
        }
        static let black = Color("colorStaticBlack")
        static let white = Color("colorStaticWhite")
        static let frameOuter = Color("colorFrameOuter")
        static let frameInner = Color("colorFrameInner")
    }
    
    
    struct Icons {
        static let tab_goals = "ic_goals_tab"
        static let tab_assistant = "ic_assistant_tab"
        static let tab_explore = "ic_explore_tab"
        static let tab_modules = "ic_modules_tab"
        static let microphone = "ic_microphone"
        static let microphone_disabled = "ic_microphone_disabled"
        static let attachment = "ic_attachment"
        static let search = "ic_search"
        static let arrowLeft = "ic_arrow_left"
        static let calendar = "ic_calendar"
        static let chevronLeft = "ic_chevron_left"
        static let chevronRight = "ic_chevron_right"
        static let close = "ic_close"
        static let edit = "ic_edit"
        static let execution = "ic_execution"
        static let filter = "ic_filter"
        static let listBullet = "ic_list_bullet"
        static let maintenance = "ic_maintenance"
        static let menu = "ic_menu"
        static let plus = "ic_plus"
        static let send = "ic_send"
        static let copy = "ic_copy"
        static let trash = "ic_trash"
        static let stop = "ic_stop"
        static let stop_filled = "ic_stop_filled"
        static let refresh = "ic_refresh"
        static let google = "ic_google"
        static let github = "ic_github"
        static let apple = "ic_apple"
        static let email = "ic_email"
        static let lock = "ic_lock"
        static let video = "ic_video"
        static let eye = "ic_eye"
        static let eye_crossed = "ic_eye_crossed"
        static let share = "ic_share"
        static let clock = "ic_clock"
        static let check = "ic_check"
        static let chat = "ic_chat"
        static let settings = "ic_settings"
        static let reload = "ic_reload"
        static let plusCircle = "ic_plus_circle"
        static let person = "ic_person"
        static let logout = "ic_logout"
        static let connectionError = "illustration_server_error"
        static let company = "ic_company"
        static let sharedWithMe = "ic_shared_with_me"
        static let schema = "ic_schema"
        static let status = "ic_status"
        static let shortcuts = "ic_shortcuts"
        static let appearance = "ic_appearance"
        static let aiModel = "ic_ai_model"
        static let recording = "ic_recording"
        static let billing = "ic_billing"
        static let members = "ic_members"
        static let alert = "ic_alert"
        static let info = "ic_info"
        static let key = "ic_key"
        static let switchRound = "ic_switch_round"
        static let promote = "ic_promote"
        static let minusCircle = "ic_minus_circle"
        static let upload = "ic_upload"
        static let speed = "ic_speed"
        static let play = "ic_play"
        static let pause = "ic_pause"
        static let volume = "ic_volume"
        static let file = "ic_file"
        static let chatBubble = "ic_chat_bubble"
        static let home = "ic_home"
        static let call = "ic_call"
        static let makeCall = "ic_make_call"
        
        static let tabProjects = "ic_tab_projects"
        static let tabTasks = "ic_tab_tasks"
        static let tabAgents = "ic_tab_agents"
        static let tabMeetings = "ic_tab_meetings"
        static let tabSettings = "ic_tab_settings"

        static let settingsAssistant = "ic_settings_assistant"
        static let openExternal = "ic_open_external"
        static let accout = "ic_account"
        static let cursorPointer = "ic_cursor_pointer"
        static let cursorHand = "ic_cursor_hand"
        static let zoomPlus = "ic_zoom_plus"
        static let zoomMinus = "ic_zoom_minus"
        static let goalOverview = "ic_goal_overview"
        static let goalRoadmap = "ic_goal_roadmap"
        static let goalTradeOffs = "ic_goal_tradeoffs"
        static let goalState = "ic_goal_state"
        static let goalConstraints = "ic_goal_constraints"
        static let goalDatasources = "ic_goal_datasources"
        static let dollar = "ic_dollar"
        static let adjustments = "ic_adjustments"
        static let trends = "ic_trends"
        static let cloud = "ic_cloud"
        static let users = "ic_users"
        static let download = "ic_download"
        static let mute = "ic_mute"
        static let endCall = "ic_end_call"
        static let expand = "ic_expand"
        static let collapse = "ic_collapse"
        static let taskStatus = "ic_task_status"
        static let flag = "ic_flag"
        static let upper = "ic_upper"
        static let switchSides = "ic_switch"
        static let minimize = "ic_minimize"
        static let maximize = "ic_maximize"
        static let transcribe = "ic_transcribe"
        
        static let taskStatusDone = "ic_task_status_done"
        static let taskStatusBlocked = "ic_task_status_blocked"
        static let taskStatusInProgress = "ic_task_status_in_progress"
        static let taskStatusOffTrack = "ic_task_status_off_track"
        static let flagOutline = "ic_flag_outline"
        static let flagFilled = "ic_flag_filled"
        static let boltOutline = "ic_bolt_outline"
        static let boltFilled = "ic_bolt_filled"
    }
    
    struct Images {
        static let logo = "logo"
        static let logoColored = "logo_colored"
        static let logotype = "logotype"
        static let serverErrorIllustration = "illustration_server_error"
        static let networkErrorIllustration = "illustration_network_error"
        static let loginIllustration = "illustration_login"
        static let noResultsIllustration = "illustration_no_results"
        static let changePasswordIllustration = "illustration_change_password"
        static let searchIllustration = "illustration_search"
        static let downloadIllustration = "illustration_download"
        static let uploadIllustration = "illustration_upload"
        static let assistantPlaceholder = "assistant_placeholder"
        static let microphoneIllustration = "illustration_microphone"
        static let meetingGoogle = "meeting_google"
        static let meetingZoom = "meeting_zoom"
    }
    
    
    struct RepositoryPaths {
        static let images = "Images"
        static let audioRecordings = "Recordings/Audios"
        static let videoRecordings = "Recordings/Videos"
    }
}
