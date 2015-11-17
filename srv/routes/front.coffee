Front = require('../models/front')

exports.register_routes = (app) ->
  app.get '/fronts', (req, res) ->
    res.render 'fronts/list', { user: req.user }

  app.get '/fronts/:id', (req, res) ->
    res.render 'fronts/detail', { user: req.user }

  app.get '/fronts/new', (req, res) ->
    res.render 'fronts/form', { user: req.user }

  app.get '/fronts/:id/edit', (req, res) ->
    res.render 'fronts/form', { user: req.user }

  app.route('/api/fronts')
    .post (req, res) ->
      Front.create
        name: req.body.name
        type: req.body.type
        dangers: req.body.dangers
        portents: req.body.portents
        cast: req.body.cast
        stakes: req.body.stakes
        description: req.body.description
        (err, data) ->
          res.status(500).send err if err
          res.send data
    .get (req, res) ->
      Front.find {}, (err, fronts) ->
        res.status(500).send err if err
        res.json fronts
    .delete (req, res) ->
      Front.remove {}, (err) ->
        res.status(500).send err if err
        res.json {success: true} unless err

  app.route('/api/fronts/:id')
    .get (req,res) ->
      Front.findById req.params.id, (err, front) ->
        res.status(500).send err if err
        if front
          res.json front
        else
          res.status(404)
    .put (req, res) ->
      Front.findOneAndUpdate {_id: req.params.id },
        name: req.body.name
        type: req.body.type
        dangers: req.body.dangers
        portents: req.body.portents
        cast: req.body.cast
        stakes: req.body.stakes
        description: req.body.description
        (err, front) ->
          res.status(500).send err if err
          if front
            res.json {success: true}
          else
            res.status(404)
    .delete (req, res) ->
      Front.findOneAndRemove {_id: req.params.id }, (err, front) ->
        res.status(500).send err if err
        if front
          res.json {success: true}
        else
          res.status(404)
