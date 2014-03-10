class HeadrestMiddleware

  constructor: (@request, apiRoot='', opts={}) ->
    @_fragmentSeparator = opts.separator or '-'

    collectionPath = @_pathWithoutApiRoot(@request.path, apiRoot)
    @fragments     = @_collectionArray(collectionPath)
    @verb          = @request.method

  id: ->
    if @isSingleResourcePath() then @fragments[@fragments.length - 1]

  collection: ->
    if @isSingleResourcePath()
      @fragments[0..-2].join(@_fragmentSeparator)
    else
      @fragments.join(@_fragmentSeparator)

  isIndex: ->
    !@isSingleResourcePath()? and (@verb == 'GET')

  isSingleResourcePath: ->
    (@fragments.length % 2) == 0

  _collectionArray: (path) ->
    list = path.split('/')
    (frag for frag in list when @_isFragmentValid(frag))

  _isFragmentValid: (str) -> str.length > 0

  _pathWithoutApiRoot: (path, apiRoot='') ->
    path.replace(apiRoot, '')


headrestMiddleware = (options={}) ->
  apiRoot = options.apiRoot or '/api/'

  (request, response, next) ->
    request.headrest  = new HeadrestMiddleware(request, apiRoot, options)

    next()


module.exports = headrestMiddleware
