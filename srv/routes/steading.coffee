Steading = require('../models/steading')

exports.register_routes = (app) ->
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
        (err, data) ->
          res.status(500).send err if err
          res.send data
    .get (req, res) ->
      Steading.find {}, (err, steadings) ->
        res.status(500).send err if err
        res.json steadings

  app.route('/api/steadings/:id')
    .get (req,res) ->
      Steading.findById req.params.id, (err, steading) ->
        res.status(500).send err if err
        if steading
          res.json steading
        else
          res.status(404).json {error: 'not found'}
    .put (req, res) ->
      Steading.findOneAndUpdate {_id: req.params.id },
        name: req.body.name
        size: req.body.size
        population: req.body.population
        prosperity: req.body.prosperity
        defenses: req.body.defenses
        colors: req.body.colors
        icon: req.body.icon
        (err, steading) ->
          res.status(500).send err if err
          if steading
            res.json steading
          else
            res.status(404).json {error: 'not found'}
    .delete (req, res) ->
      Steading.findOneAndRemove {_id: req.params.id }, (err, steading) ->
        res.status(500).send err if err
        if steading
          res.json {success: true}
        else
          res.status(404).json {error: 'not found'}
