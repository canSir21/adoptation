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
        already_exists = User.find_by(email: email)

        if already_exists[:email] == email
            raise GraphQL::ExecutionError.new("Email address is already taken")
        else
            if confirm_password.eql? auth_provider&.[](:credentials)&.[](:password)
                pass_exists = User.find_by(password: confirm_password)
    
                if pass_exists
                    raise GraphQL::ExecutionError.new("Password already taken")
                else
                    user = User.new(
                        name: name, 
                        email: email,
                        password: confirm_password
                    )

                    if (user.save)
                        {
                            user: user,
                            errors: []
                        }
                    else
                        {
                            user: nil,
                            errors: user.errors.full_message
                        }
                    end
                end
                
            else raise GraphQL::ExecutionError.new("Passwords do not match")
            end
        end
    end
end