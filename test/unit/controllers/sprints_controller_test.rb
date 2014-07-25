require "test_helper"

class SprintsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  attr_reader :sprint
  
  setup do
    sign_in create(:developer)
    @sprint = Sprint.create!
  end
  
  
  context "#add_task" do
    should "add the given task to the sprint" do
      task = create(:task)
      assert_difference "sprint.tasks.count", +1 do
        post :add_task, id: sprint.id, task_id: task.id
        assert_response :ok
      end
    end
  end
  
  
  context "#remove_task" do
    should "remove the given task from the sprint" do
      task = create(:task)
      sprint.tasks.add task
      assert_difference "sprint.tasks.count", -1 do
        delete :remove_task, id: sprint.id, task_id: task.id
        assert_response :ok
      end
    end
  end
  
  
end
