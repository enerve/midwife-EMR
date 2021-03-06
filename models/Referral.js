/*
 * -------------------------------------------------------------------------------
 * Referral.js
 *
 * The model for referral data.
 * -------------------------------------------------------------------------------
 */

var moment = require('moment')
  , val = require('validator')
  , Promise = require('bluebird')
    // Default settings used unless Bookshelf already initialized.
  , dbSettings = require('../config').database
  , Bookshelf = (require('bookshelf').DB || require('./DB').init(dbSettings))
  , Referral = {}
  ;

/*
CREATE TABLE `referral` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `referral` varchar(300) NOT NULL,
  `reason` varchar(300) DEFAULT NULL,
  `updatedBy` int(11) NOT NULL,
  `updatedAt` datetime NOT NULL,
  `supervisor` int(11) DEFAULT NULL,
  `pregnancy_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pregnancy_id` (`pregnancy_id`),
  KEY `updatedBy` (`updatedBy`),
  KEY `supervisor` (`supervisor`),
  CONSTRAINT `referral_ibfk_1` FOREIGN KEY (`pregnancy_id`) REFERENCES `pregnancy` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `referral_ibfk_2` FOREIGN KEY (`updatedBy`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `referral_ibfk_3` FOREIGN KEY (`supervisor`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1
*/

Referral = Bookshelf.Model.extend({
  tableName: 'referral'

  , permittedAttributes: ['id', 'date', 'referral', 'reason',
      'updatedBy', 'updatedAt', 'supervisor', 'pregnancy_id']

  , initialize: function() {
    this.on('saving', this.saving, this);
    }

  , saving: function(model) {
      // Enforce permittedAttributes.
      Bookshelf.Model.prototype.saving.apply(this, model);
    }

  // --------------------------------------------------------
  // Relationships
  // --------------------------------------------------------

  , pregnancy: function() {
      return this.belongsTo(require('./Pregnancy').Pregnancy, 'pregnancy_id');
    }

}, {
  // --------------------------------------------------------
  // Class Properties.
  // --------------------------------------------------------

  /* --------------------------------------------------------
   * checkFields()
   *
   * Check the validity of the passed fields and return a
   * promise whether they are sufficient or not.
   *
   * param       flds - object containing field keys and values
   * return      undefined
   * -------------------------------------------------------- */
  checkFields: function(flds) {
    return new Promise(function(resolve, reject) {
      var msgs = []
        ;
      if (! val.isLength(flds.date, 1)) msgs.push('Referral date must be specified.');
      if (! val.isLength(flds.referral, 1)) msgs.push('Referral type must be specified.');
      if (! val.isDate(flds.date)) msgs.push('Referral date is not a date.');

      if (msgs.length != 0) {
        reject(msgs.join(' '));
      } else {
        resolve(flds);
      }
    });
  }

});

Referrals = Bookshelf.Collection.extend({
  model: Referral
});

module.exports = {
  Referral: Referral
  , Referrals: Referrals
};

