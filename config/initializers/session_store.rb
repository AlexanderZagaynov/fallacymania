Rails.application.config.session_store :active_record_store, key: '_fallacymania_session'
ActionDispatch::Session::ActiveRecordStore.session_class = Session
