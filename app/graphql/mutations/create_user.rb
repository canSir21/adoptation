class Mutations::CreateUser < Mutations::BaseMutation
    argument :name, String, required: true
    
    class AuthProviderSignupData < Types::BaseInputObject
        argument :credentials, Types::AuthProviderCredentialsInput, required: false
    end

    argument :auth_provider, AuthProviderSignupData, required: false
    argument :confirm_password, String, required: true, validates: { length: {minimum:8, maximum:14}}


    field :user, Types::UserType, null: false
    field :errors, [String], null: false

    def resolve(name:,auth_provider: nil, confirm_password:)
        email = auth_provider&.[](:credentials)&.[](:email)
        password = auth_provider&.[](:credentials)&.[](:password)
        already_exists = User.find_by(email: email)
       
        return raise GraphQL::ExecutionError.new("Email is already taken") if already_exists
        return raise GraphQL::ExecutionError.new("Passwords do not match") unless confirm_password.eql? password
        
        user = User.new(name: name, email: email,password: confirm_password)
        return {user: user, errors: []} if user.save
        return {user: nil, errors: user.errors.full_message}
    end
end