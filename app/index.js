'use strict';
var util = require('util'),
    path = require('path'),
    yeoman = require('yeoman-generator'),
    _ = require('lodash'),
    _s = require('underscore.string'),
    pluralize = require('pluralize'),
    asciify = require('asciify');

var AngularCaveman2Generator = module.exports = function AngularCaveman2Generator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(AngularCaveman2Generator, yeoman.generators.Base);

AngularCaveman2Generator.prototype.askFor = function askFor() {

  var cb = this.async();

  console.log('\n' +
    '+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+\n' +
    '|a|n|g|u|l|a|r| |c|a|v|e|m|a|n|2| |g|e|n|e|r|a|t|o|r|\n' +
    '+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+\n' +
    '\n');

  var prompts = [{
    type: 'input',
    name: 'baseName',
    message: 'What is the name of your application?',
    default: 'myapp'
  }];

  this.prompt(prompts, function (props) {
    this.baseName = props.baseName;

    cb();
  }.bind(this));
};

AngularCaveman2Generator.prototype.app = function app() {

  this.entities = [];
  this.resources = [];
  this.generatorConfig = {
    "baseName": this.baseName,
    "entities": this.entities,
    "resources": this.resources
  };
  this.generatorConfigStr = JSON.stringify(this.generatorConfig, null, '\t');

  this.template('_generator.json', 'generator.json');
  this.template('_package.json', 'package.json');
  this.template('_bower.json', 'bower.json');
  this.template('bowerrc', '.bowerrc');
  this.template('Gruntfile.js', 'Gruntfile.js');
  this.copy('gitignore', '.gitignore');

  var publicDir = 'static/'
  var srcDir = 'src/'
  var tDir = 't/'
  var templatesDir = 'templates/'
  var templatesErrorsDir = 'templates/_errors/'
  this.mkdir(publicDir);
  this.mkdir(srcDir);
  this.mkdir(tDir);
  this.mkdir(templatesDir);
  this.mkdir(templatesErrorsDir);
  this.template('_app.asd', this.baseName + '.asd');
  this.template('_app-test.asd', this.baseName + '-test.asd');
  this.template('_app.lisp', 'app.lisp');
  this.template('_shlyfile.lisp', 'shlyfile.lisp');
  this.template('src/_config.lisp', srcDir + 'config.lisp');
  this.template('src/_main.lisp', srcDir + 'main.lisp');
  this.template('src/_model.lisp', srcDir + 'model.lisp');
  this.template('src/_view.lisp', srcDir + 'view.lisp');
  this.template('src/_web.lisp', srcDir + 'web.lisp');
  this.template('t/_app.lisp', tDir + 'app.lisp');
  this.template('templates/_errors/404.html', templatesErrorsDir + '404.html');

  var publicCssDir = publicDir + 'css/';
  var publicJsDir = publicDir + 'js/';
  var publicViewDir = publicDir + 'views/';
  this.mkdir(publicCssDir);
  this.mkdir(publicJsDir);
  this.mkdir(publicViewDir);
  this.template('public/_index.html', publicDir + 'index.html');
  this.copy('public/css/app.css', publicCssDir + 'app.css');
  this.template('public/js/_app.js', publicJsDir + 'app.js');
  this.template('public/js/home/_home-controller.js', publicJsDir + 'home/home-controller.js');
  this.template('public/views/home/_home.html', publicViewDir + 'home/home.html');
};

AngularCaveman2Generator.prototype.projectfiles = function projectfiles() {
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
};
