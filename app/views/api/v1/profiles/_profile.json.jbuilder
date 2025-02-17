json.extract! profile, :id, :name, :bio, :avatar, :level
json.email profile.user.email if profile.user.present? 
json.url api_v1_profile_url(profile)
