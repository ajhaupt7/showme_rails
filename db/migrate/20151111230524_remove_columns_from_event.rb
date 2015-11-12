class RemoveColumnsFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :title
    remove_column :events, :facebook_rsvp_url
  end
end
