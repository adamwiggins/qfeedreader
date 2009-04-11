# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_feedreader_session',
  :secret      => '73682a6bbec5821a4c5b39ff00631312a62035cf903e4d1fbc8816a706f4bcba9f5a1c544d70e84067064ad2b3b68b46a86d8c1f37889e5a5b94e6f7119f7f45'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
