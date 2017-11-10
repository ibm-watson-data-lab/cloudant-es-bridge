// external modules
var request = require('request');
var cloudant = require('cloudant');

// write data to ElasticSearch
var writeToES = function(verb, url, id, doc) {

  // append id to url
  if (url[url.length-1] !== '/') {
    url += '/';
  }
  url += id;

  // return a Promise
  return new Promise(function(resolve, reject) {

    // formulate HTTP request
    delete doc._id;
    delete doc._rev;
    var r = {
      method: verb,
      url: url,
      json: true
    };
    if (verb.toLowerCase() !== 'delete') {
      r.qs = {
        op_type: 'create'
      }
      r.body = doc;
    }
    console.log('r', r);

    // do HTTP request
    request(r, function(err, req, data) {
      console.log('request', req.statusCode, data);
      if (err) {
        reject(err);
      } else {
        resolve(data);
      }
    });
  });
};

// entry point for OpenWhisk
var main = function(opts) {
  if (!opts.host || !opts.username || !opts.password || !opts.dbname || !opts.id || !opts.elasticurl) {
    return new Error('Missing default parameter');
  }

  // cloudant connection
  var conn = { 
    account: opts.host, 
    username: opts.username, 
    password: opts.password, 
    plugin: 'promises'
  };
  var db = cloudant(conn).db.use(opts.dbname);

  // read the Cloudant doc
  if (opts.deleted === true) {
    return writeToES('delete', opts.elasticurl, opts.id, null);
  } else {
    return db.get(opts.id).then(function(doc) {
      return writeToES('put', opts.elasticurl, opts.id, doc);
    });
  }

};