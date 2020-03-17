Sequel.migration do
	up do
	    create_table(:sports) do
	      primary_key :id
	      String :name, null: false
	    end
  	end

  	down do
    	drop_table(:sports)
  	end
end