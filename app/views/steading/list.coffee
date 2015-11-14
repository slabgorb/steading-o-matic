class SteadingOMatic.Views.SteadingList extends SteadingOMatic.Views.List
  itemView: "SteadingItem"
  formView: "SteadingForm"
  itemCollection: "Steading"

  events: ->
    _.extend super(),
      'click .action-add-village': 'actionAddVillage'
      'click .action-add-town': 'actionAddTown'
      'click .action-add-city': 'actionAddCity'
      'click .action-add-keep': 'actionAddKeep'

  actionAddVillage: -> @collection.trigger 'addNew', 'village'

  actionAddTown: -> @collection.trigger  'addNew', 'town'

  actionAddCity: -> @collection.trigger 'addNew', 'city'

  actionAddKeep: -> @collection.trigger 'addNew', 'keep'
