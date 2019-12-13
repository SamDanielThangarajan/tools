# gmail scripts

## Steps
1. Create a google client in your account.

2. Download the secret file.

3. export GMAIL_SECRET_FILE to the path of the secret file.

4. export GMAIL_TOKEN_FILE to the path of the token file.  
   _token file is not created yet._

5. execute aa.py to authenticate and authorise your app.  
   _the scope of the app is set to just readonly, change to the desired scope_

6. To read unread mail count  
   ```
   get_label -t $GMAIL_TOKEN_FILE -l INBOX

   use -f to only fetch the needed fields from the label.
   ```
