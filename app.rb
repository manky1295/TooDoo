require 'sinatra'

class ToDoClass
  attr_accessor :title, :description, :id, :category, :completed, :color

  def initialize title, description, id, category, urgent: FALSE, important: FALSE, completed: FALSE
    @title = title
    @description = description
    @id = id
    @category = category
    @completed = completed
    if urgent
      if important
        @color = "red"
      else
        @color = "orange"
      end
    else
      if important
        @color = "green"
      else
        @color = "lightgreen"
      end
    end
  end
end

tasks = []

t1 = ToDoClass.new("Shop Groceries", "Shop for Milk , bread etc", 0, 'home', completed: false, urgent: TRUE, important: TRUE)
t2 = ToDoClass.new("Pay Bills", "Pay Electricity and Broadband bills", 1, 'work', completed: false, urgent: TRUE)
t3 = ToDoClass.new("Shop Groceries", "Shop for Milk , bread etc", 2, 'home', completed: false, important: TRUE)
t4 = ToDoClass.new("Pay Bills", "Pay Electricity and Broadband bills", 3, 'work', completed: false)

tasks << t1
tasks << t2
tasks << t3
tasks << t4

get '/' do
  data = Hash.new
  data["tasks"] = tasks
  erb :index, locals: data
end

post '/add' do
  if params["urgent"].to_i == 1
    urgent = TRUE
  else
    urgent = FALSE
  end

  if params["important"].to_i == 1
    important = TRUE
  else
    important = FALSE
  end
  todo = ToDoClass.new(params["task_title"], params["task_desc"], tasks.length, params["category"], urgent: urgent, important: important)
  tasks << todo
  puts params
  return redirect '/'
end

post '/state_change' do
  tasks.each do |task|
    if task.id == params["taskid"].to_i
      task.completed = !task.completed
      return redirect '/'
    end
  end
  return redirect '/'
end