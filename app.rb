require 'sinatra'
require 'data_mapper'
DataMapper.setup(:default,'sqlite://'+ Dir.pwd + '/project.db')

class ToDoClass
  include DataMapper::Resource

  property :id,  Serial
  property :title, String
  property :description, String
  property :category, String
  property :completed, Boolean
  property :urgent, Boolean
  property :important,  Boolean
  property :color, String

end

DataMapper.finalize
DataMapper.auto_upgrade!

# tasks = []
#
# t1 = ToDoClass.new("Shop Groceries", "Shop for Milk , bread etc", 0, 'home', completed: false, urgent: TRUE, important: TRUE)
# t2 = ToDoClass.new("Pay Bills", "Pay Electricity and Broadband bills", 1, 'work', completed: false, urgent: TRUE)
# t3 = ToDoClass.new("Shop Groceries", "Shop for Milk , bread etc", 2, 'home', completed: false, important: TRUE)
# t4 = ToDoClass.new("Pay Bills", "Pay Electricity and Broadband bills", 3, 'work', completed: false)
#
# tasks << t1
# tasks << t2
# tasks << t3
# tasks << t4

get '/' do
  data = Hash.new
  data[:tasks] = ToDoClass.all
  erb :index, locals: data
end

post '/add' do
  todo = ToDoClass.new(title: params["task_title"],description: params["task_desc"],category: params["category"], urgent: params["urgent"], important:params["important"],color:"")
  if todo.urgent
    if todo.important
      todo.color = "red"
    else
      todo.color = "orange"
    end
  else
    if important
      todo.color = "green"
    else
      todo.color = "lightgreen"
    end
  end
  todo.save
  puts params
  return redirect '/'
end

post '/state_change' do
  task_id = params["taskid"]
  todo = ToDoClass.get(task_id)
  todo.completed = !todo.completed
  todo.save
  return redirect '/'
end