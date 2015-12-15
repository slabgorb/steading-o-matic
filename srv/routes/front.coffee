Front = require('../models/front')
_ = require 'underscore'

exports.register_routes = (app) ->
  app.get '/fronts', (req, res) ->
    res.render 'fronts/list', { user: req.user }

  app.route('/api/fronts')
    .post (req, res) ->
      Front.create req.body, (err, data) ->
        res.status(500).send err if err
        res.send data
    .put (req, res) ->
      err = null
      _.each req.body, (front) ->
        Front.findOneAndUpdate {_id: front._id }, front, (e, f) ->
          err ?= e
        res.send err if err
        res.json {success: true} unless err

    .get (req, res) ->
      Front.find {user: req.user }, null, { sort: { ordinal: 1 } }, (err, fronts) ->
        res.status(500).send err if err
        res.json fronts
    .delete (req, res) ->
      Front.remove {}, (err) ->
        res.send err if err
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
      Front.findOneAndUpdate {_id: req.params.id }, req.body, (err, front) ->
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
