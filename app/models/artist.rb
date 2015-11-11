class Artist < ActiveRecord::Base
  belongs_to :event

  def create_person
    Artist.create(name: "Tacocat", song_preview: "https://p.scdn.co/mp3-preview/71d7443507729afd29b5f2aedea02334b9bcdef3", image_url: "https://i.scdn.co/image/a516b56efeed4a7b4aca2c62e8b050cd05e78a74")
  end
end
