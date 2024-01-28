class User < ApplicationRecord
    before_create :generate_auth_secret

    validates :email, email: true, presence: true
    validates :first_name, :last_name, presence: true

    has_many :access_grants,
                      class_name: "Doorkeeper::AccessGrant",
                      foreign_key: :resource_owner_id,
                      dependent: :delete_all # or :destroy if you need callbacks

    has_many :access_tokens,
                      class_name: "Doorkeeper::AccessToken",
                      foreign_key: :resource_owner_id,
                      dependent: :delete_all # or :destroy if you need callbacks

    has_many :collections, dependent: :delete_all
    has_many :user_sessions, dependent: :delete_all

    def self.generate_auth_salt
        ROTP::Base32.random(16)
    end

    def auth_code(salt)
        totp(salt).now
    end

    def valid_auth_code?(salt, code)
        # 5mins validity
        totp(salt).verify(code, drift_behind: 300).present?
    end

    private

    # This is used as a secret for this user to
    # generate their OTPs, keep it private.
    def generate_auth_secret
        self.auth_secret = ROTP::Base32.random(16)
    end

    def totp(salt)
        ROTP::TOTP.new(auth_secret + salt, issuer: "Image-Sync")
    end
end
