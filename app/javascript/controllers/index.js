// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

// Import and register all your controllers from the importmap under controllers/*

// import { Application } from "@hotwired/stimulus"
// import { definitionsFromContext } from "stimulus/webpack-helpers"

// // Start the Stimulus application
// const application = Application.start()

// // Load all the controllers defined in the importmap under controllers/*
// const context = require.context("controllers", true, /\.js$/)
// application.load(definitionsFromContext(context))
