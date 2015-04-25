###*
# @ngdoc directive
# @name newgroup Dialog
# @restrict A
# @description The dialog that generates a via link to the page h is currently
# loaded on.
###
module.exports = ['$timeout', '$rootScope', ($timeout, $rootScope) ->
    link: (scope, elem, attrs, ctrl) ->
        ## Watch vialinkvisble: when it changes to true, focus input and selection.
        scope.$watch (-> scope.groupDialog), (visble) ->
            if visble
                $timeout (-> elem.find('#via').focus().select()), 0, false

        scope.newgroup = ->
        	$rootScope.views.push(
        		{socialview:scope.groupName, icon:'h-icon-group'}
        	)
        	$rootScope.socialview = scope.groupName
        	scope.icon = 'h-icon-group'

    controller: 'AppController'
    templateUrl: 'newgroup_dialog.html'
]
