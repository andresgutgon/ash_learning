import { buildUrl, type RouteQueryOptions, type RouteDefinition, type RouteDefinitionWithParameters, type WayfinderUrl } from './../../../wayfinder'

/**
 * @see AshLearningWeb.Auth.SessionsController::create
 * @see lib/ash_learning_web/controllers/auth/sessions_controller.ex:18
 * @route /login
*/

export const create = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
  url: create.url(options).path,
  method: 'post',
})

create.definition = {
  methods: ["post"],
  url: '/login',
  parameters: {}
} satisfies RouteDefinitionWithParameters<['post']>

create.url = (options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: create.definition,
    options
  })
}

create.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
  url: create.url(options).path,
  method: 'post',
})

/**
 * @see AshLearningWeb.Auth.SessionsController::delete
 * @see lib/ash_learning_web/controllers/auth/sessions_controller.ex:45
 * @route /login
*/

export const deleteMethod = (options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
  url: deleteMethod.url(options).path,
  method: 'delete',
})

deleteMethod.definition = {
  methods: ["delete"],
  url: '/login',
  parameters: {}
} satisfies RouteDefinitionWithParameters<['delete']>

deleteMethod.url = (options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: deleteMethod.definition,
    options
  })
}

deleteMethod.delete = (options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
  url: deleteMethod.url(options).path,
  method: 'delete',
})

/**
 * @see AshLearningWeb.Auth.SessionsController::index
 * @see lib/ash_learning_web/controllers/auth/sessions_controller.ex:7
 * @route /login
*/

export const login = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: login.url(options).path,
  method: 'get',
})

login.definition = {
  methods: ["get"],
  url: '/login',
  parameters: {}
} satisfies RouteDefinitionWithParameters<['get']>

login.url = (options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: login.definition,
    options
  })
}

login.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: login.url(options).path,
  method: 'get',
})


const SessionsController = { create, delete: deleteMethod, login }

export default SessionsController
