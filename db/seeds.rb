# Create an admin user if it doesn't conflict with existing data
admin_email = ENV.fetch(['SF_EMAIL'], 'admin@example.com')
admin_password = ENV.fetch(['SF_PASSWORD'], 'password')
admin_name = ENV.fetch(['SF_NAME'], 'admin')
u = User.new(email:    admin_email,
             password: admin_password,
             name:     admin_name)
u.save! if u.valid?

# Read in data from a Google spreadsheet (if account details and spreadsheet set) and save any that do not conflict
sword_form_service_account = ENV.fetch(['SWORD_FORM_SERVICE_ACCOUNT'], nil)
google_application_credentials = ENV.fetch(['GOOGLE_APPLICATION_CREDENTIALS'], nil)
sword_form_spreadsheet = ENV.fetch(['SWORD_FORM_SPREADSHEET'], nil)

return unless sword_form_service_account || google_application_credentials
return unless sword_form_spreadsheet

if sword_form_service_account
  GoogleSheetData.new(sword_form_service_account, sword_form_spreadsheet)
else
  GoogleSheetData.new(google_application_credentials, sword_form_spreadsheet)
end
