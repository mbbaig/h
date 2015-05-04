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
                $timeout (-> elem.find('#nameGroup').focus().select()), 0, false

        scope.$watch (-> scope.showLink), (visble) ->
            if visble
                $timeout (-> elem.find('#copyLink').focus().select()), 0, false

        scope.groupName = "groupName"
        scope.showLink = false

        scope.newgroup = ->
            $rootScope.socialview.selected = false
            $rootScope.views.push({name:scope.groupName, icon:'h-icon-group', selected:true})
            $rootScope.socialview = {name:scope.groupName, icon:'h-icon-group', selected:true}
            scope.showLink = true
            scope.groupLink = "https://hypothes.is/g/102498/" + scope.groupName

    controller: 'AppController'
    templateUrl: 'newgroup_dialog.html'
]
