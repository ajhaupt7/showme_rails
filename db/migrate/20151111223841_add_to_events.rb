class AddToEvents < ActiveRecord::Migration
  def change
    add_column :events, :bandsintown_id, :integer
    add_column :events, :title, :string
    add_column :events, :facebook_rsvp_url, :string
  end
end
