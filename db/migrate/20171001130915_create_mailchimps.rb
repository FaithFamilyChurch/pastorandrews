class CreateMailchimps < ActiveRecord::Migration[5.0]
  def change
    create_table :mailchimps do |t|
      t.text :apikey
      t.string :service
      t.integer :reqs_per_day
      t.text :service_url

      t.timestamps
    end
  end
end
