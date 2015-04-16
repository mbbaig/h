###*
# @ngdoc directive
# @name View Control
# @restrict A
# @description
###

module.exports = ['$timeout', ($timeout) ->
  link: (scope, elem, attr, ctrl) ->
    scope.addview = ->
      scope.views.push {socialview:scope.addviewtext, icon:'group-icon', selected:true, removable:true, editmenu:false, essential:false}
      scope.addviewtext = ''

  ### Should probably be moved to controllers.coffee when there is an actual backend in place. ###
  # controller: 'socialViewController'
  controller: 'WidgetController'
  restrict: 'ACE'
  templateUrl: 'viewcontrol.html'
]