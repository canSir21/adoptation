class User < ApplicationRecord   
    attr_accessor :password

    validates :email, :presence => true, :uniqueness => true
    before_save :encrypt_password
    
    has_many :posts

    def encrypt_password
        self.password_salt = BCrypt::Engine.generate_salt
        self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
    
    def self.authenticate(email, password)
        user = User.find_by email: email
        return user if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
        return nil
    end

end
