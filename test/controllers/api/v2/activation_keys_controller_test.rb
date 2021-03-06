# encoding: utf-8
#
# Copyright 2014 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

require "katello_test_helper"

module Katello
  class Api::V2::ActivationKeysControllerTest < ActionController::TestCase

    def self.before_suite
      models = ["ActivationKey", "KTEnvironment",
                "ContentView", "ContentViewEnvironment", "ContentViewVersion"]
      disable_glue_layers(["Candlepin", "ElasticSearch"], models)
      super
    end

    def models
      @activation_key = katello_activation_keys(:simple_key)
      @organization = get_organization
      @view = katello_content_views(:library_view)
      @library = @organization.library

      ActivationKey.stubs('any_readable?').with(@organization).returns(true)
      stub_find_organization(@organization)
    end

    def setup
      setup_controller_defaults_api
      login_user(User.find(users(:admin)))
      @request.env['HTTP_ACCEPT'] = 'application/json'
      @fake_search_service = @controller.load_search_service(Support::SearchService::FakeSearchService.new)

      models
    end

    def test_index
      @fake_search_service.stubs(:retrieve).returns([[@activation_key], 1])
      @fake_search_service.stubs(:total_items).returns(1)

      results = JSON.parse(get(:index, :organization_id => @organization.id).body)

      assert_response :success
      assert_template 'api/v2/activation_keys/index'

      assert_equal results.keys.sort, ['page', 'per_page', 'results', 'search', 'sort', 'subtotal', 'total']
      assert_equal results['results'].size, 1
      assert_equal results['results'][0]['id'], @activation_key.id
    end

    def test_show
      results = JSON.parse(get(:show, :id => @activation_key.id).body)

      assert_equal results['name'], 'Simple Activation Key'

      assert_response :success
      assert_template 'api/v2/activation_keys/show'
    end

    def test_create
      post :create, :environment_id => @library.id, :content_view_id => @view.id,
           :activation_key => {:name => 'Key A', :description => 'Key A, Key to the World'}

      results = JSON.parse(response.body)
      assert_equal results['name'], 'Key A'
      assert_equal results['description'], 'Key A, Key to the World'

      assert_response :success
      assert_template 'katello/api/v2/common/create'
    end

  end
end
