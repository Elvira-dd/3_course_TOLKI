json.extract! user, :id, :email, :admin
json.url api_v1_user_url(user)
json.name user.profile.name
json.bio user.profile.bio
json.level user.profile.level