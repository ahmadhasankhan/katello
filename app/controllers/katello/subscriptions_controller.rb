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
require 'ostruct'

module Katello
class SubscriptionsController < Katello::ApplicationController

  before_filter :find_provider
  before_filter :authorize

  def rules
    read_provider_test = lambda{@provider.readable?}
    {
      :index => read_provider_test,
      :all => read_provider_test
    }
  end

  def index
    render 'bastion/layouts/application', :layout => false
  end

  def all
    redirect_to :action => 'index', :anchor => '/subscriptions'
  end

  def controller_display_name
    return 'subscription'
  end

  def find_provider
    @provider = current_organization.redhat_provider
  end

end
end
