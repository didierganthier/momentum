# Testing Guide for Habit Notifications

## 🧪 Quick Start Testing

### Prerequisites
- Physical device (iOS or Android) - emulator notifications are unreliable
- App installed and running
- Notification permissions granted

## 📱 Basic Functionality Tests

### Test 1: Create Habit with Reminder
**Steps:**
1. Open the app
2. Tap the **+** button
3. Enter habit name: "Test Notification"
4. Select any category
5. Tap **"Set a reminder time"**
6. Set time to **2 minutes from now**
7. Tap **Save**

**Expected:**
- Success message shows with reminder time
- Habit appears in list
- After 2 minutes, notification should appear

**Verify:**
- Notification title includes habit name
- Notification body says "Keep your streak going! 🔥"
- Tapping notification opens the app

---

### Test 2: Create Habit without Reminder
**Steps:**
1. Tap the **+** button
2. Enter habit name: "No Reminder Habit"
3. Select any category
4. Do NOT set a reminder time
5. Tap **Save**

**Expected:**
- Success message: "Habit added successfully!"
- Habit appears in list
- No notification scheduled

---

### Test 3: Delete Habit with Reminder
**Steps:**
1. Create a habit with a reminder
2. Swipe left on the habit (or long press → delete)
3. Confirm deletion

**Expected:**
- Habit removed from list
- Notification canceled (won't fire at scheduled time)

**Verify:**
You can check pending notifications with this debug code:
```dart
final pending = await NotificationService().getPendingNotifications();
print('Pending notifications: ${pending.length}');
```

---

### Test 4: Multiple Habits with Different Times
**Steps:**
1. Create "Morning Meditation" - reminder at 8:00 AM
2. Create "Lunch Walk" - reminder at 12:00 PM
3. Create "Evening Reading" - reminder at 8:00 PM

**Expected:**
- All three habits saved
- Three notifications scheduled
- Each fires at its specific time

---

### Test 5: Clear Reminder Before Saving
**Steps:**
1. Tap the **+** button
2. Set a reminder time
3. Tap the **X** icon to clear it
4. Save the habit

**Expected:**
- Reminder cleared
- Habit saved without notification
- No notification scheduled

---

## 🎯 Platform-Specific Tests

### iOS Tests

#### Test: First Launch Permission Request
**Steps:**
1. Fresh install (uninstall first if needed)
2. Launch app
3. Wait for permission dialog

**Expected:**
- System permission dialog appears
- Three options: Allow, Don't Allow, Not Now
- After allowing, notifications work

#### Test: Permission Denied Scenario
**Steps:**
1. Deny notification permission
2. Create habit with reminder

**Expected:**
- Habit saves normally
- Notification scheduled (but won't display)
- No crash or error

**Note:** User must manually enable in Settings > Notifications > Momentum

---

### Android Tests

#### Test: Android 13+ Permission Request
**Steps:**
1. Fresh install on Android 13+ device
2. Launch app
3. Create first habit with reminder

**Expected:**
- System permission dialog appears
- "Allow" or "Don't allow" options
- After allowing, notifications work

#### Test: Exact Alarm Permission
**Steps:**
1. Go to Settings > Apps > Momentum > Alarms & reminders
2. Check if "Allow setting alarms and reminders" is enabled

**Expected:**
- Toggle should be ON
- If OFF, notifications may be delayed

#### Test: Battery Optimization
**Steps:**
1. Settings > Apps > Momentum > Battery > Unrestricted
2. Set reminder for 5 minutes from now
3. Turn off screen
4. Wait for notification

**Expected:**
- Notification fires exactly at scheduled time
- Even with screen off

---

## 🔄 Persistence Tests

### Test: App Restart
**Steps:**
1. Create habit with reminder (5 minutes from now)
2. Force close the app
3. Wait for notification time

**Expected:**
- Notification still fires
- App opens when tapped

---

### Test: Device Reboot
**Steps:**
1. Create habit with reminder (30 minutes from now)
2. Note the exact time
3. Restart device
4. Wait for notification time (don't open app)

**Expected:**
- Notification fires at scheduled time
- Android: Should reschedule after boot
- iOS: May require app launch once

**Note:** This is a known limitation on iOS. Notifications may need app to be opened once after reboot.

---

### Test: Cloud Sync with Reminders
**Steps:**
1. Device 1: Logged out (local mode)
2. Create habit with 9:00 AM reminder
3. Sign in to sync
4. Device 2: Sign in with same account

**Expected:**
- Device 1: Habit syncs to cloud, notification remains scheduled
- Device 2: Habit appears, but notification NOT automatically scheduled
  
**Note:** Currently notifications are device-local. Device 2 would need to set its own reminder.

---

## ⏰ Time-Based Tests

### Test: Past Time Handling
**Steps:**
1. Create habit at 3:00 PM
2. Set reminder for 2:00 PM (earlier today)

**Expected:**
- Notification scheduled for 2:00 PM **tomorrow**
- Does not fire immediately

---

### Test: Timezone Change
**Steps:**
1. Create habit with 9:00 AM reminder
2. Change device timezone
3. Check notification time

**Expected:**
- Notification should adjust to new timezone
- May require app restart

**Note:** Uses `tz.local` which updates on timezone change.

---

## 🐛 Edge Case Tests

### Test: Rapid Creation/Deletion
**Steps:**
1. Create habit with reminder
2. Immediately delete it
3. Create another habit with same name and time
4. Repeat 5 times quickly

**Expected:**
- No crashes
- Only the last habit's notification is scheduled
- Old notifications properly canceled

---

### Test: Same Time for Multiple Habits
**Steps:**
1. Create "Habit A" - reminder at 10:00 AM
2. Create "Habit B" - reminder at 10:00 AM
3. Create "Habit C" - reminder at 10:00 AM

**Expected:**
- All three saved successfully
- All three notifications scheduled
- All three fire at 10:00 AM (may appear stacked)

---

### Test: Midnight Crossing
**Steps:**
1. At 11:55 PM, create habit with reminder at 12:05 AM

**Expected:**
- Notification scheduled for tomorrow (next day)
- Fires at correct time

---

## 📊 Debug Commands

Add these to your code for debugging:

```dart
// Check pending notifications
final pending = await NotificationService().getPendingNotifications();
for (var n in pending) {
  print('ID: ${n.id}, Title: ${n.title}, Body: ${n.body}');
}

// Cancel all notifications
await NotificationService().cancelAllReminders();

// Test immediate notification
await NotificationService().scheduleHabitReminder(
  habitId: 'test',
  habitName: 'Test Habit',
  time: TimeOfDay.now(),
);
```

---

## ✅ Test Results Template

Copy this template to track your testing:

```
### Test Session: [Date]
**Device:** [iPhone 15 Pro / Samsung Galaxy S23 / etc.]
**OS Version:** [iOS 17.0 / Android 14 / etc.]

- [ ] Create habit with reminder
- [ ] Create habit without reminder
- [ ] Delete habit with reminder
- [ ] Multiple habits different times
- [ ] Clear reminder before saving
- [ ] Permission request (first launch)
- [ ] Permission denied scenario
- [ ] App restart persistence
- [ ] Device reboot persistence
- [ ] Past time handling
- [ ] Same time multiple habits
- [ ] Notification tap opens app

**Issues Found:**
1. [Describe any issues]
2. 

**Notes:**
[Any additional observations]
```

---

## 🎯 Success Criteria

The notification feature is working correctly if:

✅ Notifications fire at exact scheduled time  
✅ Notifications display correct habit name  
✅ Notifications survive app restart  
✅ Notifications survive device reboot (Android)  
✅ Deleting habit cancels notification  
✅ Multiple reminders work independently  
✅ Permissions are requested appropriately  
✅ No crashes when permission denied  
✅ Tapping notification opens app  
✅ Works in both local and cloud mode  

---

## 🚨 Common Issues & Solutions

### Issue: Notifications not appearing
**Solutions:**
1. Check notification permissions in device settings
2. Verify battery optimization is disabled
3. Check exact alarm permission (Android 12+)
4. Ensure time is set to future, not past
5. Try physical device (not emulator)

### Issue: Notifications delayed by several minutes
**Solutions:**
1. Disable battery optimization
2. Enable "Allow setting alarms and reminders" (Android)
3. Use `exactAllowWhileIdle` mode (already implemented)

### Issue: Notifications disappear after reboot
**Solutions:**
1. Check `RECEIVE_BOOT_COMPLETED` permission
2. Verify boot receiver in AndroidManifest.xml
3. On iOS, open app once after reboot

### Issue: Permission dialog not appearing
**Solutions:**
1. Fresh install (uninstall first)
2. Check if permission already granted/denied
3. Reset app data in device settings

---

## 📝 Reporting Issues

When reporting notification issues, include:

1. **Device & OS**: "iPhone 14, iOS 17.2"
2. **Steps to reproduce**: Detailed list
3. **Expected behavior**: What should happen
4. **Actual behavior**: What actually happened
5. **Screenshots**: If relevant
6. **Logs**: Console output if available

---

**Happy Testing! 🎉**
