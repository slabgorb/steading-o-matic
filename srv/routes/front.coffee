Front = require('../models/front')
_ = require 'underscore'

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
      Front.create req.body, (err, data) ->
        res.status(500).send err if err
        res.send data
    .put (req, res) ->
      err = null
      _.each req.front, (front) ->
        Front.findOneAndUpdate {_id: front.id }, front, (e, f) ->
          err ?= e
        res.status(500).send err if err
        res.json {success: true} unless err

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
    .patch (req, res) ->
      Front.findById req.params.id, (err, front) ->
        front.patch(req.patch)
        res.json front

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
