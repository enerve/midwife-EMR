/*
 * -------------------------------------------------------------------------------
 * users.js
 *
 * Functionality for the management of users.
 * -------------------------------------------------------------------------------
 */

var _ = require('underscore')
  , User = require('../models').User
  , Users = require('../models').Users
  , cfg = require('../config')
  ;


/* --------------------------------------------------------
 * load()
 *
 * Loads the user record from the database based upon the id
 * as specified in the path. Places the user record in the
 * request as paramUser. Does not include the password field.
 *
 * param       req
 * param       res
 * param       next - callback
 * return      undefined
 * -------------------------------------------------------- */
var load = function(req, res, next) {
  var id = req.params.id
    ;

  User.forge({id: id})
    .fetch()
    .then(function(rec) {
      if (! rec) return next();
      rec = _.omit(rec.toJSON(), ['password']);
      if (rec) req.paramUser = rec;
      next();
    });
};


/* --------------------------------------------------------
 * list()
 *
 * Renders a screen that lists the users in the system. Does
 * not render the password, updatedBy, supervisor or 
 * password fields. Renders status as Yes or No.
 *
 * param       req
 * param       res
 * return      undefined
 * -------------------------------------------------------- */
var list = function(req, res) {
  var omit = ['password', 'updatedBy', 'supervisor'];
  Users.forge()
    .fetch()
    .then(function(list) {
      var userList = [];
      list.forEach(function(rec) {
        var r = rec.toJSON()
          , sts = r.status
          ;
        r.status = req.gettext('Yes');
        if (sts == 0) r.status = req.gettext('No');
        userList.push(_.omit(r, omit));
      });
      res.render('userList', {
        title: req.gettext('List of Users')
        , user: req.session.user
        , users: userList
      });
    });
};

/* --------------------------------------------------------
 * addForm()
 *
 * Renders the form used to add a new user into the system.
 *
 * param       req
 * param       res
 * return      undefined
 * -------------------------------------------------------- */
var addForm = function(req, res) {
  var blankUser = {
      username: ''
      , firstname: ''
      , lastname: ''
      , password: ''
      , email: ''
      , lang: ''
      , 'status': ''
      , comment: ''
    }
    ;
  res.render('userAddForm', {
    title: req.gettext('Add User')
    , user: req.session.user
    , success: true
    , messages: []
    , editUser: blankUser
  });
};

/* --------------------------------------------------------
 * getEditFormData()
 *
 * Returns an object representing the data that is rendered
 * when the edit form is displayed.
 *
 * param       req
 * param       addData  - (Object) additional data
 * return      Object
 * -------------------------------------------------------- */
var getEditFormData = function(req, addData) {
  return _.extend(addData, {
    title: req.gettext('Edit User')
    , user: req.session.user
    , editUser: _.extend(req.paramUser, {password: '', password2: ''})
  });
};

/* --------------------------------------------------------
 * editForm()
 *
 * Renders the form used to edit a user.
 *
 * param       req
 * param       res
 * return      undefined
 * -------------------------------------------------------- */
var editForm = function(req, res) {
  if (req.paramUser) {
    res.render('userEditForm', getEditFormData(req, {success: true, messages: []}));
  } else {
    res.redirect(cfg.path.userList);
  }
};

/* --------------------------------------------------------
 * update()
 *
 * Updates the user in the database after checking the fields
 * for validity. If password is specified, checks then hashes
 * the password before saving.
 *
 * param       req
 * param       res
 * return      undefined
 * -------------------------------------------------------- */
var update = function(req, res) {
  var processPw = true
     , data = {}
    , fldsToOmit = ['password2','_csrf']
    ;
  if (req.paramUser &&
      req.body &&
      req.paramUser.id &&
      req.body.id &&
      req.paramUser.id == req.body.id) {
    if (req.body.password.length == 0 || req.body.password2.length == 0) {
      processPw = false;
    }
    User.checkFields(req.body, false, processPw, function(err, result) {
      var editObj
        , user
        ;
      if (result.success) {
        if (! processPw) {
          // If the password is not specified, do not replace it with an
          // empty string in the database.
          fldsToOmit.push('password');
        }
        editObj = _.extend({
                      updatedBy: req.session.user.id
                    }, _.omit(req.body, fldsToOmit));
        user = new User(editObj);
        if (processPw) {
          user.hashPassword(editObj.password, function(er2, success) {
            if (er2) return console.error(er2);
            user.save(null, {method: 'update'})
              .then(function(model) {
                res.redirect(cfg.path.userList);
              });
          });
        } else {
          user.save(null, {method: 'update'})
            .then(function(model) {
              res.redirect(cfg.path.userList);
            });
        }
      } else {
        data.success = false;
        data.messages = result.messages;
        res.render('userEditForm', getEditFormData(req, data));
      }
    });
  } else {
    console.error('Error in update of user: user not found.');
    res.redirect(cfg.path.userList);
  }
};

/* --------------------------------------------------------
 * create()
 *
 * Creates the user after sanity checking the fields for
 * validity.
 *
 * param       req
 * param       res
 * return      undefined
 * -------------------------------------------------------- */
var create = function(req, res) {
  var data = {
      title: req.gettext('Add User')
      , user: req.session.user
      , messages: [req.gettext('User was created.')]
      , success: true
  };
  User.checkFields(req.body, true, true, function(err, result) {
    var newUserObj
      , user
      ;

    if (result.success) {
      newUserObj = _.extend({status: 1
                  , updatedBy: req.session.user.id
                  }, _.omit(req.body, ['password2', '_csrf']));
      user = new User(newUserObj);
      user.hashPassword(newUserObj.password, function(err, success) {
        if (err) return console.error(err);
        user.save()
          .then(function(model) {
            res.redirect(cfg.path.userList);
          });
      });
    } else {
      data.success = false;
      data.messages = result.messages;
      res.render('userAddForm', data);
    }
  });
};

module.exports = {
  list: list
  , addForm: addForm
  , create: create
  , load: load
  , editForm: editForm
  , update: update
};

