Steading = require('../models/steading')

exports.register_routes = (app) ->
  app.get '/steadings', (req, res) ->
    res.render 'steadings/list', { user: req.user }

  app.get '/steadings/:id', (req, res) ->
    res.render 'steadings/detail', { user: req.user }

  app.get '/steadings/new', (req, res) ->
    res.render 'steadings/form', { user: req.user }

  app.get '/steadings/:id/edit', (req, res) ->
    res.render 'steadings/form', { user: req.user }

  app.route('/api/steadings')
    .post (req, res) ->
      Steading.create
        name: req.body.name
        size: req.body.size
        population: req.body.population
        prosperity: req.body.prosperity
        defenses: req.body.defenses
        colors: req.body.colors
        icon: req.body.icon
        tags: req.body.tags
        description: req.body.description
        order: req.body.order
        (err, data) ->
          res.status(500).send err if err
          res.send data
    .get (req, res) ->
      Steading.find {}, (err, steadings) ->
        res.status(500).send err if err
        res.json steadings
    .delete (req, res) ->
      Steading.remove {}, (err) ->
        res.status(500).send err if err
        res.json {success: true} unless err

  app.route('/api/steadings/:id')
    .get (req,res) ->
      Steading.findById req.params.id, (err, steading) ->
        res.status(500).send err if err
        if steading
          res.json steading
        else
          res.status(404)
    .put (req, res) ->
      Steading.findOneAndUpdate {_id: req.params.id },
        name: req.body.name
        size: req.body.size
        population: req.body.population
        prosperity: req.body.prosperity
        defenses: req.body.defenses
        colors: req.body.colors
        icon: req.body.icon
        tags: req.body.tags
        description: req.body.description
        order: req.body.order
        (err, steading) ->
          res.status(500).send err if err
          if steading
            res.json {success: true}
          else
            res.status(404)
    .delete (req, res) ->
      Steading.findOneAndRemove {_id: req.params.id }, (err, steading) ->
        res.status(500).send err if err
        if steading
          res.json {success: true}
        else
          res.status(404)
