/* 
 * -------------------------------------------------------------------------------
 * pregnancy.js
 *
 * Functionality for management of pregnancies.
 * ------------------------------------------------------------------------------- 
 */

var _ = require('underscore')
  , Promise = require('bluebird')
  , moment = require('moment')
  , cfg = require('../config')
  , Patient = require('../models').Patient
  , Patients = require('../models').Patients
  , Pregnancy = require('../models').Pregnancy
  , Pregnancies = require('../models').Pregnancies
  , SelectData = require('../models').SelectData
  , logInfo = require('../util').logInfo
  , logWarn = require('../util').logWarn
  , logError = require('../util').logError
  , maritalStatus = []
  , religion = []
  ;

/* --------------------------------------------------------
 * init()
 *
 * Initialize the module.
 * -------------------------------------------------------- */
var init = function() {
  var refresh
    , maritalName = 'maritalStatus'
    , religionName = 'religion'
    , interval = 1 * 30 * 1000    // TODO: fix hard-code.
  ;

  // --------------------------------------------------------
  // TODO: move this logic back to the ORM so that each
  // cluster does not have to do it.
  // --------------------------------------------------------
  refresh = function(dataName) {
    return new Promise(function(resolve, reject) {
      logInfo('Refreshing ' + dataName);
      SelectData.getSelect(dataName)
        .then(function(list) {
          resolve(list);
        })
        .caught(function(err) {
          err.status = 500;
          reject(err);
        });
    });
  };

  // --------------------------------------------------------
  // Keep marital status up to date.
  // --------------------------------------------------------
  refresh(maritalName).then(function(list) {
    maritalStatus = list;
  });
  setInterval(function() {
    refresh(maritalName).then(function(list) {
      maritalStatus = list;
    });
  }, interval);

  // --------------------------------------------------------
  // Keep religion up to date.
  // --------------------------------------------------------
  refresh(religionName).then(function(list) {
    religion = list;
  });
  setInterval(function() {
    refresh(religionName).then(function(list) {
      religion = list;
    });
  }, interval);
};

/* --------------------------------------------------------
 * load()
 *
 * Loads the pregnancy record from the database based upon the id
 * as specified in the path. Places the pregnancy record in the
 * request as paramPregnancy.
 *
 * param       req
 * param       res
 * param       next - callback
 * return      undefined
 * -------------------------------------------------------- */
var load = function(req, res, next) {
  var id = req.params.id
    ;

  Pregnancy.forge({id: id})
    .fetch({withRelated: ['patient']})
    .then(function(rec) {
      if (! rec) return next();
      rec = rec.toJSON();
      rec.patient.dob = moment(rec.patient.dob).format('MM-DD-YYYY');
      if (rec) req.paramPregnancy = rec;
      next();
    });
};

/* --------------------------------------------------------
 * addForm()
 *
 * Display the form to create a new pregnancy record.
 *
 * param       req
 * param       res
 * param       next - callback
 * return      undefined
 * -------------------------------------------------------- */
var addForm = function(req, res) {
  var data = {title: req.gettext('New Pregnancy Record') }
    ;
  res.render('pregnancyAddForm', getEditFormData(req, data));
};

/* --------------------------------------------------------
 * getEditFormData()
 *
 * Returns an object representing the data that is rendered
 * when the edit form is displayed. Expects the caller to
 * pass the key/value pair for title in addData.
 *
 * param       req
 * param       addData  - (Object) additional data
 * return      Object
 * -------------------------------------------------------- */
var getEditFormData = function(req, addData) {
  var ms = _.map(maritalStatus, function(m) {return _.clone(m);})
    , rel = _.map(religion, function(r) {return _.clone(r);})
    ;
  if (req.paramPregnancy && req.paramPregnancy.maritalStatus) {
    _.each(ms, function(rec) {
      if (rec.selectKey == req.paramPregnancy.maritalStatus) {
        rec.selected = true;
      } else {
        rec.selected = false;
      }
    });
  }
  if (req.paramPregnancy && req.paramPregnancy.religion) {
    _.each(rel, function(rec) {
      if (rec.selectKey == req.paramPregnancy.religion) {
        rec.selected = true;
      } else {
        rec.selected = false;
      }
    });
  }
  return _.extend(addData, {
    user: req.session.user
    , messages: req.flash()
    , marital: ms
    , religion: rel
    , rec: req.paramPregnancy
  });
};

/* --------------------------------------------------------
 * editForm()
 *
 * Displays the edit form for the pregnancy.
 *
 * param       
 * return      
 * -------------------------------------------------------- */
var editForm = function(req, res) {
  var data = {title: req.gettext('Edit Pregnancy')};
  if (req.paramPregnancy) {
    res.render('pregnancyEditForm', getEditFormData(req, data));
  } else {
    // Pregnancy not found.
    res.redirect(cfg.path.search);
  }
};

/* --------------------------------------------------------
 * create()
 *
 * Create a new patient record and the corresponding pregnancy
 * record to go along with it. Insures that the required fields
 * are provided otherwise does not change the database.
 *
 * param       req
 * param       res
 * return      undefined
 * -------------------------------------------------------- */
var create = function(req, res) {
  var common = {
        updatedBy: req.session.user.id
      }
    , dob = req.body.dob.length > 0? req.body.dob: null
    , doh = req.body.doh.length > 0? req.body.doh: null
    , pregFlds = _.omit(req.body, ['_csrf', 'dob'])
    , patFlds = {}
    ;

  if (req.session.roleInfo.isStudent) {
    common.supervisor = req.session.supervisor.id;
  }
  pregFlds = _.extend(pregFlds, common);
  patFlds = _.extend(common, {dob: dob, dohID: doh});

  // --------------------------------------------------------
  // Validate the fields.
  // --------------------------------------------------------
  Promise.all([Patient.checkFields(patFlds), Pregnancy.checkFields(pregFlds)])
    .then(function(result) {
      return _.object(['patFlds', 'pregFlds'], result);
    })
    // --------------------------------------------------------
    // Save patient and pregnancy records.
    // --------------------------------------------------------
    .then(function(flds) {
      Patient
        .forge(flds.patFlds)
        .save()
        .then(function(patient) {
          var pregFields = _.extend(flds.pregFlds, {patient_id: patient.get('id')});
          Pregnancy
            .forge(pregFields)
            .save()
            .then(function(pregnancy) {
              req.flash('info', req.gettext('Pregnancy was created.'));
              res.redirect(cfg.path.pregnancyEditForm.replace(/:id/, pregnancy.get('id')));
            })
            .caught(function(e) {
              logError('Error saving pregnancy record. Orphan patient record id: ' + patient.get('id'));
              throw e;
            });
        })
        .caught(function(e) {
          logError('Error saving patient record: ' + e);
          throw e;
        });
    })
    .caught(function(e) {
      logError(e);
      res.status(406);
      res.end();    // TODO: need a custom 406 page.
    });
};

var update = function(req, res) {
  var pregFlds
    , patFlds
    , dob = req.body.dob.length > 0? req.body.dob: null
    , doh = req.body.doh.length > 0? req.body.doh: null
    ;
  if (req.paramPregnancy &&
      req.body &&
      req.paramPregnancy.id &&
      req.body.id &&
      req.paramPregnancy.id == req.body.id) {

    pregFlds = _.omit(req.body, ['_csrf', 'doh', 'dob', 'priority']);
    patFlds = {dohID: doh, dob: moment(dob, 'MM-DD-YYYY').format('YYYY-MM-DD')};
    patFlds = _.extend(patFlds, {id: req.paramPregnancy.patient_id});
    Pregnancy.checkFields(pregFlds).then(function(flds) {
      Pregnancy.forge(flds).save().then(function() {
        Patient
          .forge(patFlds)
          .save()
          .then(function(patient) {
            req.flash('info', req.gettext('Pregnancy was updated.'));
            res.redirect(cfg.path.pregnancyEditForm.replace(/:id/, flds.id));
          })
          .caught(function(err) {
            logError(err);
            res.redirect(cfg.path.search);
          });
      })
      .caught(function(err) {
        logError(err);
        res.redirect(cfg.path.search);
      });
    })
    .caught(function(err) {
      logError(err);
      res.redirect(cfg.path.search);
    });

  } else {
    logError('Error in update of pregnancy: pregnancy not found.');
    res.redirect(cfg.path.search);
  }
};

// --------------------------------------------------------
// Initialize the module.
// --------------------------------------------------------
init();

module.exports = {
  addForm: addForm
  , create: create
  , load: load
  , editForm: editForm
  , update: update
};

