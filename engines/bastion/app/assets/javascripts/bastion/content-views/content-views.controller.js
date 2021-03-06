/**
 * Copyright 2014 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public
 * License as published by the Free Software Foundation; either version
 * 2 of the License (GPLv2) or (at your option) any later version.
 * There is NO WARRANTY for this software, express or implied,
 * including the implied warranties of MERCHANTABILITY,
 * NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
 * have received a copy of GPLv2 along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
*/

/**
 * @ngdoc object
 * @name  Bastion.content-views.controller:ContentViewsController
 *
 * @requires $scope
 * @requires Nutupane
 * @requires ContentView
 * @requires CurrentOrganization
 *
 * @description
 *   Provides the functionality specific to ContentViews for use with the Nutupane UI pattern.
 *   Defines the columns to display and the transform function for how to generate each row
 *   within the table.
 */
angular.module('Bastion.content-views').controller('ContentViewsController',
    ['$scope', 'Nutupane', 'ContentView', 'CurrentOrganization',
    function ($scope, Nutupane, ContentView, CurrentOrganization) {

        var nutupane = new Nutupane(ContentView, {
            'nondefault':       true,
            'organization_id':  CurrentOrganization,
            'sort_by':          'name',
            'sort_order':       'ASC'
        }, 'queryPaged');

        $scope.table = nutupane.table;
        $scope.removeRow = nutupane.removeRow;

        $scope.table.closeItem = function () {
            $scope.transitionTo('content-views.index');
        };

    }]
);
