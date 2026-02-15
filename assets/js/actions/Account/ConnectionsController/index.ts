import { buildUrl, type RouteQueryOptions, type RouteDefinition, type RouteDefinitionWithParameters, type WayfinderUrl } from './../../../wayfinder'

/**
 * @see AshLearningWeb.Account.ConnectionsController::delete
 * @route /account/connections/:provider/:uid
*/

export const deleteAccountConnection = (args: { provider: string | number, uid: string | number } | [string | number, string | number], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
  url: deleteAccountConnection.url(args, options).path,
  method: 'delete',
})

deleteAccountConnection.definition = {
  methods: ["delete"],
  url: '/account/connections/:provider/:uid',
  parameters: { provider: { name: "provider", optional: false, required: true, glob: false }, uid: { name: "uid", optional: false, required: true, glob: false } }
} satisfies RouteDefinitionWithParameters<['delete']>

deleteAccountConnection.url = (args: { provider: string | number, uid: string | number } | [string | number, string | number],  options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: deleteAccountConnection.definition,
    args,
    options
  })
}

deleteAccountConnection.delete = (args: { provider: string | number, uid: string | number } | [string | number, string | number], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
  url: deleteAccountConnection.url(args, options).path,
  method: 'delete',
})

/**
 * @see AshLearningWeb.Account.ConnectionsController::index
 * @route /account/connections
*/

export const accountConnections = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: accountConnections.url(options).path,
  method: 'get',
})

accountConnections.definition = {
  methods: ["get"],
  url: '/account/connections',
  parameters: {}
} satisfies RouteDefinitionWithParameters<['get']>

accountConnections.url = (options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: accountConnections.definition,
    options
  })
}

accountConnections.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: accountConnections.url(options).path,
  method: 'get',
})


const ConnectionsController = { deleteAccountConnection, accountConnections }

export default ConnectionsController
