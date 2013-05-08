class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :permalink
      t.text :content
      # t.slug :string

      t.timestamps
    end
    # add_index :pages, :slug, unique: true
  end
end
