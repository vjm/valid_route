class CreateNamespacedWhizzers < ActiveRecord::Migration
  def change
    create_table :namespaced_whizzers do |t|
      t.string :permalink

      t.timestamps
    end
  end
end
