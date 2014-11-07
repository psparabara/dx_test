require 'spec_helper'
require_relative 'steps/managing_posts_steps_macro'
require_relative 'macros/authentication_feature_macro'

feature 'managing posts' do
  include ManagingPostsStepsMacro
  include AuthenticationFeatureMacro
  include ApplicationHelper

  scenario 'writing posts' do
    given_i_am_a_admin_user
    and_i_am_signed_in
    when_i_go_to_new_post_path
    and_fill_the_form_with_a_valid_post
    then_i_shoud_be_in_my_dashboard
    and_see_post_created_message
  end

  scenario 'editing posts' do
    given_i_am_a_admin_user
    and_i_am_signed_in
    when_i_go_to_edit_post_path
    and_change_post_properties_in_the_edit_form
    then_i_shoud_be_in_my_dashboard
    and_see_post_edited_message
  end

  scenario 'deleting posts' do
    given_i_am_a_admin_user
    and_i_am_signed_in
    and_have_some_posts
    and_i_am_in_my_dashboard_page
    when_i_click_on_a_post_delete_link
    then_i_shoud_be_in_my_dashboard
    and_see_no_more_that_post
    and_a_proper_deleted_message
  end
end