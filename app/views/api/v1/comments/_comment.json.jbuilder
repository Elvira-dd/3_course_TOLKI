json.extract! comment, :id, :user_id, :content

json.created_at comment.created_at.strftime('%d.%m')
json.user_name comment.user.profile.name if comment.user.profile
