class CreateMailchimpLists < ActiveRecord::Migration[5.0]
  def change
    create_table :mailchimp_lists do |t|
      t.integer :mailchimp_id
      t.string :name
      t.string :list_id

      t.timestamps
    end
  end
end
