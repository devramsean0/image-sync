class UserSession < ApplicationRecord
    belongs_to :user

    def self.generate(user)
        auth_secret = ROTP::Base32.random(16)
        email_code = ROTP::TOTP.new(auth_secret + user.auth_secret, issuer: "Image-Sync").now
        cookie = SecureRandom.hex(16)
        #ip = request.remote_ip
        create(user_id: user.id, cookie: cookie, email_code: email_code)
    end
end
