class Page extends Controller
  constructor:($scope, pageService)->

    $scope.orderedTasks = ""
    $scope.orderedTasksError = ""
    $scope.orderedTasksStatus = ""

    $scope.orderTasks = ->
      pageService.order($scope.tasks_structure)
      .success (data) ->
        $scope.orderedTasksStatus = data.status
        if data.status == 'ok'
          $scope.orderedTasks = data.order
        else
          $scope.orderedTasksError = data.error
