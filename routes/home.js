/* 
 * -------------------------------------------------------------------------------
 * home.js
 *
 * Routes for home and logging in.
 * ------------------------------------------------------------------------------- 
 */

var passport = require('passport')
  , loginRoute = '/login'
  ;

var home = function(req, res) {
  console.log('home');
  res.render('content', {
    title: 'Testing'
    , user: {
      id: req.session.userid
      // TODO: hardcode
      , username: 'kurt'
    }
  });
};

var login = function(req, res) {
  console.log('login');
  var data = {
    title: 'Please log in'
    , message: req.session.messages
  };
  res.render('login', data);
};

var loginPost = function(req, res, next) {
  console.log('loginPost');
  passport.authenticate('local', function(err, user, info) {
    if (err) {
      console.log('err: %s', err);
      return next(err);
    }
    if (!user) {
      if (req.session) {
        req.session.messages =  [info.message];
      }
      return res.redirect(loginRoute);
    }
    req.logIn(user, function(err) {
      if (err) { return next(err); }
      console.log('logIn() success');
      req.session.userid = user.id;
      return res.redirect('/');
    });
  })(req, res, next);
};

var logout = function(req, res) {
  console.log('logout');
  req.session.destroy(function(err) {
    res.redirect(loginRoute);
  });
};



module.exports = {
  home: home
  , login: login
  , loginPost: loginPost
  , logout: logout
};


