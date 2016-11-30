# Pace

## Current Tasks

### Views
- [ ] HomeViewController
- [ ] NewRunViewController
	- [ ] Validations for each text field
	- [ ] Conditional segue for height
	- [ ] Conditional segue for genre
	- [ ] Drop-down for genre selection
	- [ ] Change font to Avenir
	- [ ] Create core graphics for rounded Spotify button
- [ ] PastRunTableViewController
	- [ ] Get run data to show up (distance, time, pace)
	- [ ] Format prototype cell
- [ ] PlaylistViewController
	- [ ] Display song data correctly
- [ ] RunSummaryViewController
	- [ ] Add map view
	- [ ] Match Run Tracker UI
- [ ] RunTrackerViewController
	- [x] Fix font sizes of timer and mileage count when app runs
	- [x] Constraints
	- [ ] Convert seconds to mm:hh:ss
- [ ] SPTAudioStreamingController
	- [ ] Get song player bar on run tracker view
- [ ] SearchViewController
	- [ ] Add auto-search as user edits search bar field
	- [ ] Pass user-selected song to the NewRunViewController to use for target bpm

### Spotify SDK
#### Note: Pull Spotify's demo project from their SDK repo for reference - it uses beta 25
- [ ] Login authentication
	- [x] User authorization
	- [x] Login authentication
	- [ ] Refresh tokens
- [ ] Music playback
	- [x] Single song playback
	- [ ] Embed music player
- [ ] Set up song querying
	- [ ] Research Spotify song attributes
	- [ ] Convert user inputs (height, pace, genre, etc.) into relevant query parms
- [ ] Create algorithm for pulling songs
	- [ ] Do we want randomized playlists or the same songs for every identical query 

### Run Tracker
- [ ] Save locations to Core Data
