// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import $ from 'jquery'
import 'cocoon-js'
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import './utilities/turbolinks_load.js'

global.$ = $
global.jQuery = $

require.context('file-loader?name=[path][name].[ext]&context=node_modules/jquery-ui-dist!jquery-ui-dist', true,    /jquery-ui\.css/ )
require.context('file-loader?name=[path][name].[ext]&context=node_modules/jquery-ui-dist!jquery-ui-dist', true,    /jquery-ui\.theme\.css/ )

Rails.start()
Turbolinks.start()
ActiveStorage.start()
