class Page extends Controller
  constructor:($scope, $timeout, pageService)->

    $scope.orderedTasks = ""
    $scope.orderedTasksError = ""
    $scope.orderedTasksStatus = ""

    live_validation_delay = 2 * 1000
    current_validation_time = null
    $scope.loading_validation = false

    $scope.temp = ""

    $scope.orderTasks = ->
      pageService.order($scope.tasks_structure)
      .success (data) ->
        $scope.orderedTasksStatus = data.status
        if data.status == 'ok'
          $scope.orderedTasks = data.order
        else
          $scope.orderedTasksError = data.error

    validateTasks = ->
      pageService.order($scope.tasks_structure)
      .success (data) ->
        if data.status == 'error'
          $scope.orderedTasksStatus = 'error'
          $scope.orderedTasksError = data.error
        else
          $scope.orderedTasksStatus = ""

    updateTempDelayed = ->
      if Date.now() - current_validation_time >= live_validation_delay
        validateTasks()
        $scope.loading_validation = false

    $scope.updateTemp = ->
      current_validation_time = Date.now()
      $scope.loading_validation = true
      $timeout ->
        updateTempDelayed()
      , live_validation_delay