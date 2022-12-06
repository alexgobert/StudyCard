# StudyCard  

**Name of project:** StudyCard  
**Team members:** Alex Gobert, Robert Horvath, Sam Song, Chris Tran  
**Dependencies:** Xcode 14.0.1, Swift 5, Firebase iOS SDK v9.0.0+

## Special Instructions  

- Test Account:
    - user: test@test.com  
    - pass: 12345678  
- You may encounter issues with non-unique bundle identifiers. If this happens, append something (like .[name]) as a workaround. Although this should break our Firebase app, we have not encountered any issues with Firebase even with an inconsistent bundle ID. We first encountered this issue shortly after presenting during class on December 5th, and we are unsure why this happened seemingly at random.

## Required Feature Checklist  

Note: If the following lists look like bullets with brackets next to them, that is because GitHub-flavored Markdown (GFM) treats `- [x]` and `- []` as checked and unchecked boxes, respectively. If you are not using GFM, then the checkboxes might not render properly.

- [x] Login/Register path with Firebase  
- [x] "Settings" screen. Behaviors:
    1. Font Style  
    2. Color Scheme  
    3. Sound Toggle  
- [x] Non-default fonts and colors used  

### Two major elements used

- [x] Core Data  
- [x] User Profile path using camera and photo library  
- [ ] Multithreading
- [ ] SwiftUI

### Minor elements used

- [x] Two+ additional view types:
    1. Search Fields
    2. Segmented Controls
    3. Switches
    4. Bar Buttons (Navigation Bar)

#### One of the following

- [x] Table View
- [ ] Collection View
- [ ] Tab VC
- [ ] Page VC

#### Two of the following

- [x] Alerts
- [ ] Popovers
- [x] Stack Views
- [ ] Scroll Views
- [ ] Haptics
- [x] User Defaults

#### At least one of the following per team member

- [x] Local notifications
- [ ] Core Graphics
- [x] Gesture Recognition
- [x] Animation
- [ ] Calendar
- [ ] Core Motion
- [ ] Core Location/MapKit
- [x] Core Audio
- [ ] Others

## Work Distribution Table  

|   Feature   | Description | Percentage Distribution |
| :---------- | ----------- | -----------: |
| Login/Register Path | Allow user to create account and login | Chris (95%)<br>Alex (5%) |
| Settings | Enables user to change visual settings, including font and colors | Chris (90%)<br>Alex (10%) |
| UI Design | Team designed UI collaboratively and worked together on compliance to theme and font choices dictated by Settings screen | Chris (40%)<br>Robert (20%)<br>Sam (20%)<br>Alex (20%) |
| Core Data | Stores flashcard sets into local storage for persistence across app launches | Robert (100%) |
| User Profile | Enables user to set a profile picture and modify account details | Sam (80%)<br>Alex (20%) |
| Search Field | Enables user to search for card sets | Robert (100%) |
| Segmented Controls | Enables user to change which appears first: term, definition, or mixed | Robert (100%) |
| Switches | Enables user to toggle flashcard shuffle and configure app settings | Chris (75%)<br>Robert (25%) |
| Table Views | Organizes data in a readable format | Chris (33%)<br>Robert (33%)<br>Alex (33%) |
| Stack Views | Stacks UI elements for easier layout | Alex (25%)<br>Robert (25%)<br>Sam (25%)<br>Chris (25%) |
| Alerts | Displays error messages | Alex (25%)<br>Robert (25%)<br>Sam (25%)<br>Chris (25%) |
| Notifications | Daily notifications to study | Robert (100%) |
| Gesture Recognition | Enables user to swipe and tap on flashcards while studying | Sam (80%)<br>Alex (20%) |
| Animation | Animates card motion and progress bar | Sam (90%)<br>Alex (10%) |
| Core Audio | Audio for card animations | Sam (100%) |
