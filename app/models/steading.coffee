class SteadingOMatic.Models.Steading extends SteadingOMatic.Models.Base
  url: -> if @get('_id') then "/api/steadings/#{@get('_id')}" else "/api/steadings"
