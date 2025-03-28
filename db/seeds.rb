# Путь для чтения слов из текстового файла
text_path = Rails.root.join('db', 'raw_text.txt')
@raw_text = File.read(text_path).strip
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

# * Технические функции
def create_sentence
  sentence_words = []
  (5..15).to_a.sample.times { sentence_words << @words.sample }
  sentence_words.join(' ').capitalize + '.'
end

def create_content
  sentence_words = []
  (10..80).to_a.sample.times { sentence_words << @words.sample }
  sentence_words.join(' ').capitalize + '.'
end

def random_rating
  rand(1..100)
end

def create_title
  long_words = @words.select { |word| word.length > 2 } 
  return "Default" if long_words.empty? 
  
  sentence_words = []
  (2..6).to_a.sample.times { sentence_words << long_words.sample }
  sentence_words.join(' ').capitalize
end

def create_name
  long_words = @words.select { |word| word.length > 2 } 
  return "Default" if long_words.empty? 
  
  sentence_words = []
  (1..3).to_a.sample.times { sentence_words << long_words.sample }
  sentence_words.join(' ').capitalize
end

def create_tag_text
  sentence_words = []
  (1..2).to_a.sample.times { sentence_words << @words.sample }
  sentence_words.join(' ').capitalize + '.'
end

def generate_random_links
  services = ["YouTube", "Яндекс Музыка", "Spotify", "Apple Music"]
  services.sample(rand(1..services.length)).map do |service|
    { service: service, url: "https://#{service.downcase}.com/#{SecureRandom.hex(4)}" }
  end
end

# * Работа с сидом
def seed
  reset_db
  create_users(16)
  create_podcast(35)
  create_issues(3..10)
  create_themes_and_assign_to_podcasts(20)
  create_post(1..4)
  create_comments(1..3)
  create_reviews(50)

  3.times { create_comment_replies }
end

def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  puts "Database reset completed"
end

# * Создание сущностей
def create_users(quantity)
  quantity.times do |i|
    user_data = { email: "user_#{i}@email.com", password: 'testtest' }
    user_data[:admin] = true if i == 0
    user_data[:is_author] = true if i >= 11
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
      average_rating: "Средняя оценка: #{random_rating}/100",
      external_links: generate_random_links,
      is_audio: rand(0..1) == 1
    )

    cover_files = Dir.entries('app/assets/images/podcast_covers').select { |file| file.match?(/\.jpg$/) }
    random_cover = cover_files.sample

    if random_cover
      podcast.cover.attach(
        io: File.open(Rails.root.join("app/assets/images/podcast_covers/#{random_cover}")),
        filename: random_cover,
        content_type: "image/jpeg"
      )
    end

    authors_to_assign = authors.sample(rand(1..3))
    podcast.authors << authors_to_assign
    puts "Podcast with id #{podcast.id} created with authors: #{authors_to_assign.map(&:id).join(', ')}"
  end
end

def create_issues(quantity)
  Podcast.all.each do |podcast|
    puts "Creating issues for podcast with id #{podcast.id}"

    quantity.to_a.sample.times do
      issue = podcast.issues.create!(
        name: "Выпуск #{create_title}",
        description: create_sentence,
        link: "https://example.com/#{SecureRandom.hex(4)}"
      )

      cover_dir = podcast.is_audio ? 'audioissue_cover' : 'issue_cover'
      cover_path = Rails.root.join('app', 'assets', 'images', cover_dir)
      cover_files = Dir.entries(cover_path).select { |f| f.match?(/\.jpg$/) }

      if cover_files.present?
        random_cover = cover_files.sample
        issue.cover.attach(
          io: File.open(File.join(cover_path, random_cover)),
          filename: random_cover,
          content_type: 'image/jpeg'
        )
      else
        puts "No cover files found in #{cover_path}"
      end
    end
  end
end

def create_post(quantity)
  Podcast.all.each do |podcast|
    quantity.to_a.sample.times do
      author = Author.all.sample
      post = podcast.posts.create!(
        title: create_title,
        content: create_content,
        hashtag: create_title,
        author: author
      )
      puts "Post with id #{post.id} just created for Podcast with id #{podcast.id}"
    end
  end
end
def create_reviews(quantity)
  users = User.all
  podcasts = Podcast.all
  tag_options = ["Интересная тема обсуждений", "Хорошая динамика беседы", "Глубокий анализ материала", "Структура повествования", "Оригинальность, инсайды", "Доступность, понятность"]

  return if users.empty? || podcasts.empty?

  quantity.times do
    user = users.sample
    podcast = podcasts.sample
    rating = rand(1..5) # Оценки от 1 до 5
    tags = tag_options.sample(rand(1..3)) # Случайное количество тегов

    review = Review.create!(
      user: user,
      podcast: podcast,
      rating: rating,
      content: create_content,
      tags: tags
    )
    
    puts "Review with id #{review.id} created by User #{user.id} for Podcast #{podcast.id} with rating #{rating}"
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
      puts "Comment created for #{commentable.class.name} with id #{comment.id}"
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
      puts "Reply created for comment with id #{comment.id}"
    end
  end
end

def create_themes_and_assign_to_podcasts(theme_count)
  themes = theme_count.times.map do |i|
    Theme.create!(name: "Theme ##{i + 1}", cover: "long_theme_cover.png", description: create_sentence)
  end

  Podcast.all.each do |podcast|
    podcast.themes = themes.sample(rand(1..3))
    puts "Assigned themes to podcast with id #{podcast.id}"
  end
end

seed