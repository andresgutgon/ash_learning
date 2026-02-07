import { buildUrl, type RouteQueryOptions, type RouteDefinition, type RouteDefinitionWithParameters, type WayfinderUrl } from './../../../wayfinder'

/**
 * @see AshLearningWeb.Auth.MagicLinkController::create
 * @see lib/ash_learning_web/controllers/auth/magic_link_controller.ex:8
 * @route /magic-link
*/

export const create = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
  url: create.url(options).path,
  method: 'post',
})

create.definition = {
  methods: ["post"],
  url: '/magic-link',
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
 * @see AshLearningWeb.Auth.MagicLinkController::update
 * @see lib/ash_learning_web/controllers/auth/magic_link_controller.ex:33
 * @route /magic-link/:id
*/

export const update = (args: { id: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'patch'> => ({
  url: update.url(args, options).path,
  method: 'patch',
})

update.definition = {
  methods: ["patch", "put"],
  url: '/magic-link/:id',
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
 * @see AshLearningWeb.Auth.MagicLinkController::edit
 * @see lib/ash_learning_web/controllers/auth/magic_link_controller.ex:25
 * @route /magic-link/:id/edit
*/

export const edit = (args: { id: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: edit.url(args, options).path,
  method: 'get',
})

edit.definition = {
  methods: ["get"],
  url: '/magic-link/:id/edit',
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


const MagicLinkController = { create, update, edit }

export default MagicLinkController
