class SteadingOMatic.Views.FrontList extends SteadingOMatic.Views.List
  itemView: "FrontItem"
  formView: "FrontForm"
  itemCollection: "Front"

  events: ->
    _.extend super(),
      'click .action-add-adventure': 'actionAddAdventure'
      'click .action-add-campaign': 'actionAddCampaign'

  actionAddAdventure: -> @collection.trigger 'addNew', 'adventure'

  actionAddCampaign: -> @collection.trigger  'addNew', 'campaign'
