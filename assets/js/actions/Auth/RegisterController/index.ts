import { buildUrl, type RouteQueryOptions, type RouteDefinition, type RouteDefinitionWithParameters, type WayfinderUrl } from './../../../wayfinder'

/**
 * @see AshLearningWeb.Auth.RegisterController::create
 * @see lib/ash_learning_web/controllers/auth/register_controller.ex:19
 * @route /register
*/

export const create = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
  url: create.url(options).path,
  method: 'post',
})

create.definition = {
  methods: ["post"],
  url: '/register',
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
 * @see AshLearningWeb.Auth.RegisterController::index
 * @see lib/ash_learning_web/controllers/auth/register_controller.ex:8
 * @route /register
*/

export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: index.url(options).path,
  method: 'get',
})

index.definition = {
  methods: ["get"],
  url: '/register',
  parameters: {}
} satisfies RouteDefinitionWithParameters<['get']>

index.url = (options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: index.definition,
    options
  })
}

index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: index.url(options).path,
  method: 'get',
})

/**
 * @see AshLearningWeb.Auth.RegisterController::update
 * @see lib/ash_learning_web/controllers/auth/register_controller.ex:54
 * @route /register/:id
*/

export const update = (args: { id: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'patch'> => ({
  url: update.url(args, options).path,
  method: 'patch',
})

update.definition = {
  methods: ["patch", "put"],
  url: '/register/:id',
  parameters: { id: { name: "id", optional: false, required: true, glob: false } }
} satisfies RouteDefinitionWithParameters<['patch', 'put']>

update.url = (args: { id: string | number } | [string | number] | string | number,  options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: update.definition,
    args,
    options
  })
}

update.patch = (args: { id: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'patch'> => ({
  url: update.url(args, options).path,
  method: 'patch',
})

update.put = (args: { id: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
  url: update.url(args, options).path,
  method: 'put',
})

/**
 * @see AshLearningWeb.Auth.RegisterController::edit
 * @see lib/ash_learning_web/controllers/auth/register_controller.ex:47
 * @route /register/:id/edit
*/

export const edit = (args: { id: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: edit.url(args, options).path,
  method: 'get',
})

edit.definition = {
  methods: ["get"],
  url: '/register/:id/edit',
  parameters: { id: { name: "id", optional: false, required: true, glob: false } }
} satisfies RouteDefinitionWithParameters<['get']>

edit.url = (args: { id: string | number } | [string | number] | string | number,  options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: edit.definition,
    args,
    options
  })
}

edit.get = (args: { id: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: edit.url(args, options).path,
  method: 'get',
})


const RegisterController = { create, index, update, edit }

export default RegisterController
