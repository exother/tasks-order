class Page extends Controller
  constructor:($scope, $timeout, pageService)->

    $scope.orderedTasks = ""
    $scope.orderedTasksError = ""
    $scope.orderedTasksStatus = ""

    live_validation_delay = 2 * 1000
    current_validation_time = null
    $scope.loading_validation = false
    $scope.tasks_structure = ''
    $scope.tasks_structure_temp = null

    $scope.temp = ""

    $scope.taskList = []
    $scope.newTaskId = ''
    $scope.newTaskName = ''

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

    $scope.addTask = ->
      $scope.taskList.push({'id': $scope.newTaskId, 'name': $scope.newTaskName})
      $scope.newTaskId = ''
      $scope.newTaskName = ''
      $timeout ->
        jQuery('select').material_select()
        jQuery('select').val(' ')
      , 300

    $scope.deleteTask = (key) ->
      $scope.taskList.splice(key, 1)

    $scope.addDependency = ->
      $scope.tasks_structure_temp = $scope.tasks_structure if $scope.dependency_element_first != ' '
      $scope.tasks_structure += $scope.dependency_element_first.trim() + ' => ' + $scope.dependency_element_second.trim() + '\n' if $scope.dependency_element_first != ' '
      $scope.updateTemp()

    $scope.backDependency = ->
      $scope.tasks_structure = $scope.tasks_structure_temp
      $scope.tasks_structure_temp = null
      $scope.updateTemp()

    $scope.scrollToTop = ->
      jQuery("html, body").animate
        scrollTop:0
      , 'slow'