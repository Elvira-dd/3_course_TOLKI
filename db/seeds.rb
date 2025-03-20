text_path = Rails.root.join('db', 'raw_text.txt')
@raw_text = File.read(text_path).strip
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

def create_sentence
  sentence_words = []

  (5..15).to_a.sample.times do
    sentence_words << @words.sample
  end

  sentence = sentence_words.join(' ').capitalize + '.'
end
def create_content
  sentence_words = []

  (10..80).to_a.sample.times do
    sentence_words << @words.sample
  end

  sentence = sentence_words.join(' ').capitalize + '.'
end
def random_rating
  rand(1..100)
end
def create_title
    sentence_words = []
  
    (2..10).to_a.sample.times do
      sentence_words << @words.sample
    end
  
    sentence = sentence_words.join(' ').capitalize + '.'
end
def create_name
    sentence_words = []
  
    (1..3).to_a.sample.times do
      sentence_words << @words.sample
    end
  
    sentence = sentence_words.join(' ').capitalize
end

def create_tag_text
    sentence_words = []
  
    (1..2).to_a.sample.times do
      sentence_words << @words.sample
    end
  
    sentence = sentence_words.join(' ').capitalize + '.'
  end
  def generate_random_links
    services = ["YouTube", "Яндекс Музыка", "Spotify", "Apple Music"]
    links = services.sample(rand(1..services.length)).map do |service|
      { service: service, url: "https://#{service.downcase}.com/#{SecureRandom.hex(4)}" }
    end
    links
  end

  def seed
    reset_db
    create_users(16)
    create_podcast(35)
    create_issues(3..10)
    create_themes_and_assign_to_podcasts(20) 
    create_post(1..4)
    create_comments(1..6)
  
    3.times do
      create_comment_replies
    end
  
    
  end
  
  def reset_db
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
  
  def create_users(quantity)
    quantity.times do |i|
      user_data = {
        email: "user_#{i}@email.com",
        password: 'testtest'
      }
      
      user_data[:admin] = true if i == 0
      user_data[:is_author] = true if i >=11
  
      user = User.create!(user_data)
      puts "User created with id #{user.id} #{user.jti}"
    end
  end

  def create_podcast(quantity)

    authors = Author.includes(:user).where(users: { is_author: true })
    return if authors.empty?
  
    quantity.times do
      podcast = Podcast.create!(
        name: create_name,
        description: create_sentence,
        # cover: "podcast_covers/podcastCover_#{rand(1..35)}.jpg",

        average_rating: "Средняя оценка: #{random_rating}/100",
        external_links: generate_random_links
      )
  # Теперь у нас есть podcast.id, обновляем обложку
  podcast.update!(cover: "podcast_covers/podcastCover_#{podcast.id}.jpg")
      # Выбираем случайное количество авторов от 1 до 3
      authors_to_assign = authors.sample(rand(1..3))
  
      # Привязываем выбранных авторов к подкасту
      podcast.authors << authors_to_assign
  
      puts "Podcast with id #{podcast.id} created with authors: #{authors_to_assign.map(&:id).join(', ')}"
    end
  end
  

  def create_issues(quantity)
    Podcast.all.each do |podcast|
      puts "Creating issues for podcast with id #{podcast.id}"
      i = 1
      quantity.to_a.sample.times do 
        issue = podcast.issues.create!(name: "Выпуск #{create_title}", cover: "issue_cover_test.png", description: create_sentence, link: "https://example.com/#{SecureRandom.hex(4)}")
        i += 1
      end
    end
  end
  
  def create_post(quantity)
    Podcast.all.each do |podcast|  
      i = 1
      quantity.to_a.sample.times do
        author = Author.all.sample  # Выбираем случайного автора вместо пользователя
  
        post = podcast.posts.create!(
          title: create_title,
          content: create_content,
          hashtag: create_title,
          author: author  # Теперь привязываем пост к автору
        )
        
        puts "Post with id #{post.id} just created for Podcast with id #{podcast.id}"
        i += 1
      end
    end
  end

  def create_comments(quantity)
    commentable_records = (Post.all + Issue.all)
  
    commentable_records.each do |commentable|
      quantity.to_a.sample.times do
        user = User.all.sample
        comment = commentable.comments.create!(
          content: create_sentence,
          user_id: user.id
        )
  
      end
    end
  end
  
  def create_comment_replies
    Comment.all.each do |comment|
      if rand(1..3) == 1
        comment_reply = comment.replies.create!(
          commentable: comment.commentable,
          content: create_sentence,
          user_id: User.all.sample.id
        )
  
        
      end
    end
  end
  
  def create_themes_and_assign_to_podcasts(theme_count)
    themes = theme_count.times.map do |i|
      Theme.create!(name: "Theme ##{i + 1}", cover:"long_theme_cover.png", description: create_sentence)
    end
    # theme_names = ["История", "Секс", "Искусство", "Исто"]
    # themes = theme_names.map { |name| Theme.find_or_create_by!(name: name) }
  
    Podcast.all.each do |podcast|
      podcast.themes = themes.sample(rand(1..3))
      puts "Assigned themes to podcast with id #{podcast.id}"
    end
  end
seed