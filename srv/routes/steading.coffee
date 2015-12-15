Steading = require('../models/steading')
_ = require 'underscore'

exports.register_routes = (app) ->
  app.get '/steadings', (req, res) ->
    res.render 'steadings/list', { user: req.user }

  app.get '/api/random/steading/:count', (req, res) ->
    Steading.findRandom({ user: req.user }).limit(req.params.count).exec (err, steadings) ->
      res.json steadings

  app.route('/api/steadings')
    .post (req, res) ->
      Steading.create req.body, (err, data) ->
        res.status(500).send err if err
        res.send data
    .put (req, res) ->
      err = null
      _.each req.body,  (steading) ->
        Steading.findOneAndUpdate {_id: steading._id}, steading, (e, s) ->
          err ?= e
      res.status(500).send err if err
      res.json {success: true} unless err
    .get (req, res) ->
      Steading.find { user: req.user }, null, { sort: { ordinal: 1 } }, (err, steadings) ->
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

    .patch (req, res) ->
      Steading.findById req.params.id, (err, steading) ->
        steading.patch(req.patch)
        res.json steading

    .put (req, res) ->
      Steading.findOneAndUpdate {_id: req.params.id }, req.body, (err, steading) ->
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
