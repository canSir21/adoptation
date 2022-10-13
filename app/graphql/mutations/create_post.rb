class Mutations::CreatePost < Mutations::BaseMutation
    
    argument :title, String, required: true
    argument :body, String, required: true
    argument :url, String, required: true

    type Types::PostType

    def resolve(title: nil, body: nil, url: nil)
        Post.create!(
            body: body,
            title: title,
            url: url,
            user: context[:current_user]
        )
    end

end