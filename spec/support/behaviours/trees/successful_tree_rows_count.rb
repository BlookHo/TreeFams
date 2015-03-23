shared_examples :successful_tree_rows_count do
  it '- check Tree have rows count - Ok' do
    trees_count =  Tree.all.count
    puts "in successful_tree_rows_count: trees_count = #{trees_count.inspect} \n"
    expect(trees_count).to eq(rows_qty) # got rows_qty of Tree
  end
end

