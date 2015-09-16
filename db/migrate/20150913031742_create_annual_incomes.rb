class CreateAnnualIncomes < ActiveRecord::Migration
  def change
    create_table :annual_incomes do |t|
      t.integer :annual_income
      t.string :value

      t.timestamps
    end
  end
end
