module Types
  class QueryType < Types::BaseObject
    # /users
    field :users, [Types::UserType], null: false
    field :posts, [Types::PostType], null:false

    def users
      User.all
    end

    # /user/:id
    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    end

    def posts 
      posts = Post.all
      posts.includes('user')
    end
    field :post, Types::PostType, null: false do
      argument :id, ID, required: true
    end
    def post(id:)
      Post.find(id)
    end
  end
end