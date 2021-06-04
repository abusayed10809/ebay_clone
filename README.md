# ebay_clone

## Packages used

  auto_size_text:
    To resize texts according to screen size

  flutter_spinkit:
    Designer circular progess indicator

  auth_buttons:
    Out of the box button for google sign in

  firebase_core:
  firebase_auth:
    To use firebase authentication functionality.

  firebase_storage:

  cloud_firestore:

  google_sign_in:
    For signing in using google, to get the google account credentials.

  provider:
    For state management across multiple screens.

## Problems Faced
    1. Structuring the database was a bit time consuming but once the backend structure
        is complete then it became quite easy to implement the whole application.
    2. The design was not anything predefined so it was a bit of a dilemma whether to
        spend more time on a good design or just go through minimal design but eventually
        it turned out to be okay.

## Project backend structure
    1. User Collection
        - contains user's email and username when they sign in using google
    2. Auction Collection
        - contains information about all the auctions
    3. Bidding Collection
        - contains information about which users have placed a bid under a particular auction post.
