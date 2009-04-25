require File.join( File.dirname( __FILE__), "test_helper")

class EnhancedNestedFormsTest < ActiveSupport::TestCase
  load_schema

  test "build association on new record" do
    project = Project.new({
      :name          => "TestProject",
      :_build_tasks  => "something"
    })

    assert_not_nil project.tasks.first
    assert project.nested_attributes_prevent_save?

    assert ! project.save
    assert project.new_record?
    assert project.tasks.first.new_record?
  end

  test "build association on existing record" do
    project = Project.create( :name => "TestProject")
    project.attributes = {
      :_build_tasks => "something"
    }

    assert_not_nil project.tasks.first
    assert project.nested_attributes_prevent_save?

    assert ! project.save
    assert project.tasks.first.new_record?
  end

  test "create association on existing record" do
    project = Project.create( :name => "TestProject")
    project.attributes = {
      :_create_tasks => "something"
    }

    assert_not_nil project.tasks.first
    assert ! project.nested_attributes_prevent_save?

    assert project.save
    assert ! project.tasks.first.new_record?
  end

  test "build nested association on existing record" do
    project = Project.create({
      :name          => "TestProjectWithUser",
      :_create_tasks => "something"
    })

    project.attributes = {
      :tasks_attributes => {
        project.tasks.first.id => {
          :id           => project.tasks.first.id,
          :_build_users => "something"
    } } }

    assert project.tasks.first.users.first.new_record?
    assert project.tasks.first.nested_attributes_prevent_save?
    assert project.nested_attributes_of_associations_prevent_save?
    assert ! project.save
  end

  test "build one to one association" do
    project = Project.new({
      :name        => "TestProject",
      :_build_user => "something"
    })

    assert_not_nil project.user
    assert project.nested_attributes_prevent_save?
    assert ! project.save
  end

  test "ie image button bug" do
    project = Project.new({
      :name           => "TestProject",
      "_build_user.x" => "something"
    })

    assert_not_nil project.user
  end

end

