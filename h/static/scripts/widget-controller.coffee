angular = require('angular')


module.exports = class WidgetController
  this.$inject = [
    '$rootScope', '$scope', 'annotationUI', 'crossframe', 'annotationMapper',
    'streamer', 'streamFilter', 'store'
  ]
  constructor:   (
     $rootScope, $scope,   annotationUI, crossframe, annotationMapper,
     streamer,   streamFilter,   store
  ) ->
    # Tells the view that these annotations are embedded into the owner doc
    $scope.isEmbedded = true
    $scope.isStream = true

    @chunkSize = 200
    loaded = []

    _loadAnnotationsFrom = (query, offset) =>
      queryCore =
        limit: @chunkSize
        offset: offset
        sort: 'created'
        order: 'asc'
      q = angular.extend(queryCore, query)

      store.SearchResource.get q, (results) ->
        total = results.total
        offset += results.rows.length
        if offset < total
          _loadAnnotationsFrom query, offset

        annotationMapper.loadAnnotations(results.rows)

    loadAnnotations = ->
      query = {}

      for p in crossframe.providers
        for e in p.entities when e not in loaded
          loaded.push e
          q = angular.extend(uri: e, query)
          _loadAnnotationsFrom q, 0

      streamFilter.resetFilter().addClause('/uri', 'one_of', loaded)

      streamer.send({filter: streamFilter.getFilter()})

    $scope.$watchCollection (-> crossframe.providers), loadAnnotations

    $scope.focus = (annotation) ->
      if angular.isObject annotation
        highlights = [annotation.$$tag]
      else
        highlights = []
      crossframe.notify
        method: 'focusAnnotations'
        params: highlights

    $scope.scrollTo = (annotation) ->
      if angular.isObject annotation
        crossframe.notify
          method: 'scrollToAnnotation'
          params: annotation.$$tag

    $scope.shouldShowThread = (container) ->
      if annotationUI.hasSelectedAnnotations() and not container.parent.parent
        annotationUI.isAnnotationSelected(container.message?.id)
      else
        true

    $scope.hasFocus = (annotation) ->
      !!($scope.focusedAnnotations ? {})[annotation?.$$tag]

    $scope.notOrphan = (container) -> !container?.message?.$orphan

    $scope.filterView = (container) ->
      console.log $scope.socialview
      if $rootScope.socialview == 'Public'
        container?.message?.permissions?.read?[0] == 'group:__world__'
      else if $rootScope.socialview == 'Personal'
        container?.message?.permissions?.read?[0] != 'group:__world__'

    $scope.select = (selectedview) ->
      $rootScope.socialview = selectedview.socialview
      $scope.icon = selectedview.icon
    
    $rootScope.socialview = 'Public'
    $rootScope.views = [
        {socialview:'Public', icon:'h-icon-public'}
        {socialview:'Personal', icon:'h-icon-lock'}
    ]

    $scope.icon = 'h-icon-public'
