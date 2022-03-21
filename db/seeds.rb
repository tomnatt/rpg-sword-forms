# Create an admin user if it doesn't conflict with existing data
admin_email = ENV['SF_EMAIL'] || 'admin@example.com'
admin_password = ENV['SF_PASSWORD'] || 'password'
admin_name = ENV['SF_NAME'] || 'admin'
u = User.new(email:    admin_email,
             password: admin_password,
             name:     admin_name)
u.save! if u.valid?

# Read in data from a Google spreadsheet (if account details and spreadsheet set) and save any that do not conflict
return unless ENV['SWORD_FORM_SERVICE_ACCOUNT'] && ENV['SWORD_FORM_SPREADSHEET']

gsd = GoogleSheetData.new(ENV['SWORD_FORM_SERVICE_ACCOUNT'], ENV['SWORD_FORM_SPREADSHEET'])
