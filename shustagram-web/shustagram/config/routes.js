/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes tell Sails what to do each time it receives a request.
 *
 * For more information on configuring custom routes, check out:
 * https://sailsjs.com/anatomy/config/routes-js
 */

module.exports.routes = {

  //  ╦ ╦╔═╗╔╗ ╔═╗╔═╗╔═╗╔═╗╔═╗
  //  ║║║║╣ ╠╩╗╠═╝╠═╣║ ╦║╣ ╚═╗
  //  ╚╩╝╚═╝╚═╝╩  ╩ ╩╚═╝╚═╝╚═╝
  // 'GET /': { action: 'view-homepage-or-redirect' },
  // 'GET /welcome/:unused?': { action: 'dashboard/view-welcome' },

  // 'GET /faq': { action: 'view-faq' },
  // 'GET /legal/terms': { action: 'legal/view-terms' },
  // 'GET /legal/privacy': { action: 'legal/view-privacy' },
  // 'GET /contact': { action: 'view-contact' },

  // 'GET /signup': { action: 'entrance/view-signup' },
  // 'GET /email/confirm': { action: 'entrance/confirm-email' },
  // 'GET /email/confirmed': { action: 'entrance/view-confirmed-email' },

  // 'GET /login': { action: 'entrance/view-login' },
  // 'GET /password/forgot': { action: 'entrance/view-forgot-password' },
  // 'GET /password/new': { action: 'entrance/view-new-password' },

  // 'GET /account': { action: 'account/view-account-overview' },
  // 'GET /account/password': { action: 'account/view-edit-password' },
  // 'GET /account/profile': { action: 'account/view-edit-profile' },


  //  ╔╦╗╦╔═╗╔═╗  ╦═╗╔═╗╔╦╗╦╦═╗╔═╗╔═╗╔╦╗╔═╗   ┬   ╔╦╗╔═╗╦ ╦╔╗╔╦  ╔═╗╔═╗╔╦╗╔═╗
  //  ║║║║╚═╗║    ╠╦╝║╣  ║║║╠╦╝║╣ ║   ║ ╚═╗  ┌┼─   ║║║ ║║║║║║║║  ║ ║╠═╣ ║║╚═╗
  //  ╩ ╩╩╚═╝╚═╝  ╩╚═╚═╝═╩╝╩╩╚═╚═╝╚═╝ ╩ ╚═╝  └┘   ═╩╝╚═╝╚╩╝╝╚╝╩═╝╚═╝╩ ╩═╩╝╚═╝
  '/terms': '/legal/terms',
  '/logout': '/api/v1/account/logout',


  //  ╦ ╦╔═╗╔╗ ╦ ╦╔═╗╔═╗╦╔═╔═╗
  //  ║║║║╣ ╠╩╗╠═╣║ ║║ ║╠╩╗╚═╗
  //  ╚╩╝╚═╝╚═╝╩ ╩╚═╝╚═╝╩ ╩╚═╝
  // …


  //  ╔═╗╔═╗╦  ╔═╗╔╗╔╔╦╗╔═╗╔═╗╦╔╗╔╔╦╗╔═╗
  //  ╠═╣╠═╝║  ║╣ ║║║ ║║╠═╝║ ║║║║║ ║ ╚═╗
  //  ╩ ╩╩  ╩  ╚═╝╝╚╝═╩╝╩  ╚═╝╩╝╚╝ ╩ ╚═╝
  // Note that, in this app, these API endpoints may be accessed using the `Cloud.*()` methods
  // from the Parasails library, or by using those method names as the `action` in <ajax-form>.
  '/api/v1/account/logout': { action: 'account/logout' },
  'PUT   /api/v1/account/update-password': { action: 'account/update-password' },
  'PUT   /api/v1/account/update-profile': { action: 'account/update-profile' },
  'PUT   /api/v1/account/update-billing-card': { action: 'account/update-billing-card' },
  'PUT   /api/v1/entrance/login': { action: 'entrance/login' },
  'POST  /api/v1/entrance/signup': { action: 'entrance/signup' },
  'POST  /api/v1/entrance/send-password-recovery-email': { action: 'entrance/send-password-recovery-email' },
  'POST  /api/v1/entrance/update-password-and-login': { action: 'entrance/update-password-and-login' },
  'POST  /api/v1/deliver-contact-form-message': { action: 'deliver-contact-form-message' },

  // custom routes
  'GET /': 'post/home',

  'GET /post': { action: 'post/home', csrf: false },
  'POST /post': { action: 'post/create', csrf: false },

  'GET /post/:id': 'post/index',
  'POST /comment/post/:id': 'comment/create',

  'GET /login': {
    view: 'pages/customauth/custom-login',
    locals: {
      layout: 'layouts/auth-layout'
    }
  },
  'GET /signup': {
    view: 'pages/customauth/custom-signup',
    locals: {
      layout: 'layouts/auth-layout'
    }
  },

  'POST /profile': 'user/update',

  'DELETE /post/:postId': 'post/delete',
  'GET /search': 'user/search',
  'GET /profile': 'user/profile',

  'POST /follow/:id': 'user/follow',
  'POST /unfollow/:id': 'user/unfollow',
  'GET /user/:id': 'user/publicprofile',

  'POST /like/:id': 'post/like',
  'POST /dislike/:id': 'post/dislike',
  'GET /likes/:id': 'post/likes',

  // things to change when populating: create.js: populateuserid, res.end()
  // 'GET /populate': { action: 'post/populate' },
  // 'POST /populate': { action: 'post/populate' },
};

