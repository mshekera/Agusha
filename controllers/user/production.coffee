
View = require '../../lib/view'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

data =
	breadcrumbs: tree.findWithParents breadcrumbs, 'production'

exports.index = (req, res) ->
	View.render 'user/production/production', res, data, req.path