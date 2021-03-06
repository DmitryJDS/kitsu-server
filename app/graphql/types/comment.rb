class Types::Comment < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A comment on a post'

  field :id, ID, null: false

  field :post, Types::Post,
    null: false,
    description: 'The post that this comment is attached to.'

  field :author, Types::Profile,
    null: false,
    description: 'The user who created this comment for the parent post.',
    method: :user

  field :content, String,
    null: false,
    description: 'Unmodified content.'

  field :content_formatted, String,
    null: false,
    description: 'Html formatted content.'

  field :parent, Types::Comment,
    null: true,
    description: 'The parent comment if this comment was a reply to another.'

  field :likes, Types::Profile.connection_type,
    null: false,
    description: 'Users who liked this comment.'

  def likes
    AssociationLoader.for(object.class, :likes, policy: :comment_like).scope(object).then do |likes|
      RecordLoader.for(User, token: context[:token]).load_many(likes.pluck(:user_id))
    end
  end

  field :replies, Types::Comment.connection_type,
    null: false,
    description: 'All replies to a specific comment.'

  def replies
    AssociationLoader.for(object.class, :replies, policy: :comment).scope(object)
  end
end
