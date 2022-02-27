admin_email = ENV['SF_EMAIL'] || 'admin@example.com'
admin_password = ENV['SF_PASSWORD'] || 'password'
admin_name = ENV['SF_NAME'] || 'admin'
User.create(email:    admin_email,
            password: admin_password,
            name:     admin_name)
