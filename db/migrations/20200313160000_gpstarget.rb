Sequel.migration do
  change do
    create_table(:gpstargets) do
      primary_key :id
      String :name, :null => false
      geom :geometry(Point,2326), :null => false
    end
  end
end