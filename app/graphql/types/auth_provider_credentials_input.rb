module Types
    class AuthProviderCredentialsInput < BaseInputObject
        graphql_name 'AUTH_PROVIDER_CREDENTIALS'
        
        argument :email, String, required: true, validates: {format: {with: URI::MailTo::EMAIL_REGEXP }}
        argument :password, String, required: true, validates: { length: {minimum:8, maximum:14} }

    end

end