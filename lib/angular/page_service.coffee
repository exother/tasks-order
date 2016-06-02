class Page extends Service
  constructor: ($http) ->

    @order = (structure) ->
      $http.post '/tasks/order.json',
        structure: structure
