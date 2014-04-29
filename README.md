# The Angular-Caveman2 generator 

A [Yeoman](http://yeoman.io) generator for [AngularJS](http://angularjs.org) and [Caveman2](http://8arrow.org/caveman/).

Caveman2 is a Common Lisp-based micro-framework.  For AngularJS integration with other micro-frameworks, see https://github.com/rayokota/MicroFrameworkRosettaStone.

## Installation

Install [Git](http://git-scm.com), [node.js](http://nodejs.org), a Common Lisp implementation (such as [SBCL](http://www.sbcl.org/)), [QuickLisp](http://www.quicklisp.org/) and [Shelly](http://shlyfile.org/).  When choosing the Postmodern ORM, also install [PostgreSQL](hhttp://www.postgresql.org/).

Install Yeoman:

    npm install -g yo

Install the Angular-Caveman2 generator:

    npm install -g generator-angular-caveman2

The above prerequisites can be installed to a VM using the [Angular-Caveman2 provisioner](https://github.com/rayokota/provision-angular-caveman2).

## Creating a Caveman2 service

In a new directory, generate the service:

    yo angular-caveman2

If you chose to use the Postmodern ORM, create a user and database in PostgreSQL as specified in the file `src/config.lisp`.

Run the service:

    APP_ENV=development shly -Lclack clackup app.lisp --port 8080

Your service will run at [http://localhost:8080](http://localhost:8080).


## Creating a persistent entity

Generate the entity:

    yo angular-caveman2:entity [myentity]

You will be asked to specify attributes for the entity, where each attribute has the following:

- a name
- a type (String, Integer, Float, Boolean, Date, Enum)
- for a String attribute, an optional minimum and maximum length
- for a numeric attribute, an optional minimum and maximum value
- for a Date attribute, an optional constraint to either past values or future values
- for an Enum attribute, a list of enumerated values
- whether the attribute is required

Files that are regenerated will appear as conflicts.  Allow the generator to overwrite these files as long as no custom changes have been made.

Run the service:

    APP_ENV=development shly -Lclack clackup app.lisp --port 8080
    
A client-side AngularJS application will now be available by running

	grunt server
	
The Grunt server will run at [http://localhost:9000](http://localhost:9000).  It will proxy REST requests to the Caveman2 service running at [http://localhost:8080](http://localhost:8080).

At this point you should be able to navigate to a page to manage your persistent entities.  

The Grunt server supports hot reloading of client-side HTML/CSS/Javascript file changes.

