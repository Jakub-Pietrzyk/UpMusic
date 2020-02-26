Faker::Config.locale = 'ang'


def random_local_avatar_fame(name)
  Rails.root.join("db/images/fames/#{name}.jpeg")
end

def random_local_avatar
  number = rand(7)
  if number != 0
    Rails.root.join("db/images/musicians/#{number}.jpeg")
  end
end

domain = "domena.pl"

SUPER_ADMIN_NAMES = [
  ["Upmusic",	"upmusic@#{domain}"]
]

MUSICIANS_NAMES = []

20.times {
  name = Faker::Artist.unique.name
  MUSICIANS_NAMES.push([name,"#{name}@#{domain}"])
}

FAMES_NAMES = [
  ["Eminem", "eminem@#{domain}"],
  ["Travis Scott", "travis@#{domain}"],
  ["Imagine Dragons", "id@#{domain}"],
  ["Skrillex", "skrillex@#{domain}"],
  ["J Cole", "j.cole@#{domain}"],
  ["Logic", "logic@#{domain}"],
  ["Billy ray cyrus", "rayCyrus@#{domain}"],
  ["Lil nas X", "lilnasx@#{domain}"],
  ["Billie Eilish", "billie@#{domain}"],
  ["Daft Punk", "daftpunk@#{domain}"],
  ["Dr dre", "drdre@#{domain}"]
]

OBSERVERS_NAME = []
40.times {
  name = Faker::Name.first_name
  OBSERVERS_NAME.push([name,"#{name}@#{domain}"])
}

FAMES_NAMES.each do |fm|
  User.find_or_create_by(email: fm[1]) do |fame|
    fame.name = fm[0]
    fame.password = "abc"
    fame.password_confirmation = "abc"
    fame.avatar = open(random_local_avatar_fame(fame[0]))
    fame.role = "fame"
    fame.save! validate: false
  end
end

MUSICIANS_NAMES.each do |mus|
  User.find_or_create_by(email: mus[1]) do |musician|
    musician.name = mus[0]
    musician.password = "abc"
    musician.password_confirmation = "abc"
    musician.avatar = open(random_local_avatar)
    musician.role = "musician"
    musician.recommendations = User.where(role: "fame").sample(2)
    musician.visited = rand(1000000)
    musician.save! validate: false
  end
end
