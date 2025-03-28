json.array! @profiles, partial: "api/v1/profiles/profile", as: :profile
json.email profile.user.email