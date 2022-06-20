# notification-filterer

Uses an hourly github action to automatically unsubscribe from notification things. 

![The Belcher kids jumping back from the computer](http://www.reactiongifs.com/r/2013/09/bobs-omg.gif)

## Set Up

1. Fork the Repo 
2. Create a personal access token 
  - go to https://github.com/settings/tokens
  - click 'Generate new token'
  - create a new token with the `repo` and `notifications` scopes
  - copy your token
  - click 'Configure SSO' and authorize any relevant organizations
3. Add your token to your fork
  - go to your fork -> repo settings -> secrets -> actions 
  `https://github.com/<your_username>/notification-filterer/settings/secrets/actions`
  - click 'New repository secret'
  - name it 'API_KEY' and paste in your token
4. Enable workflows on the repo
  - go to the actions tab of your fork and enable workflows
  - click on the 'Filter Notifications' workflow on the left and Run Workflow to test!

