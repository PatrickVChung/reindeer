MEDHUB_LOG_FILE = Rails.root.join('log', 'medhub_api.log')
MedhubLog = Logger.new(MEDHUB_LOG_FILE)
MedhubLog.level = :info # Set the desired log level for this custom logger

# In your code:
#MedhubLog.info("This message goes to special.log")
